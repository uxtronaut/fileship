class UserFile < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader

  belongs_to :folder

  attr_accessible :name, :attachment, :folder_id, :password, :password_confirmation

  attr_accessor :share_emails, :share_message
  attr_accessor :password_confirmation

  validates_presence_of :attachment
  validates_presence_of :folder_id
  validates_presence_of :name, :on => :update
  validates_confirmation_of :password, :allow_blank => true

  after_create :set_name, :set_token
  before_save :remove_empty_password
  
  after_destroy :remove_id_directory

  def extension
    File.extname(name)[1..-1]
  end

  def set_name
    update_attribute(:name, attachment.file.filename)
  end

  def set_token
    update_attribute(:link_token, SecureRandom.hex(6))
  end

  def remove_empty_password
    if password.blank?
      self.password = nil
    end
  end


  # Removes the useless directory left behind when a user_file is deleted
  def remove_id_directory
    FileUtils.remove_dir("#{Rails.root}/public/uploads/user_file/attachment/#{self.id}", 
                          :force => true)
  end


  # Purges all files that are older than the number of days set in app.yml.
  def self.purge_old_files
    days_until_purge = Fileship::Application.config.fileship_config['days_until_purge']
    UserFile.all.each do |user_file|
      if user_file.created_at.to_date + days_until_purge < Date.today
        user_file.destroy
      end
    end
  end
end
