# == Schema Information
#
# Table name: user_files
#
#  id         :integer          not null, primary key
#  attachment :string(255)
#  name       :string(255)
#  link_token :string(255)
#  password   :string(255)
#  folder_id  :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :integer
#

# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class UserFile < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader
  


  belongs_to :folder
  belongs_to :user
  has_one :file_log
  has_many :file_revisions

  attr_accessible :name, :attachment, :folder_id, :password, :password_confirmation, :user_id

  attr_accessor :share_emails, :share_message
  attr_accessor :password_confirmation

  validates_presence_of :attachment
  validates_presence_of :user_id
  validates_presence_of :folder_id
  validates_presence_of :name, :on => :update
  validates_confirmation_of :password, :allow_blank => true

  after_create :create_log, :set_name, :set_token
  before_save :remove_empty_password, :name_changed
  
  before_destroy :deleted
  after_destroy :remove_id_directory


  # Creates a log of the file's key information
  def create_log
    FileLog.create_log(self)
  end


  # Records the file's time of deletion in the file log
  def deleted
    self.file_log.update_attributes(:deleted_at => Time.now) unless self.file_log.blank?
  end


  # Increments the number of times the file has been downloaded
  def downloaded
    self.file_log.increment(:downloads, 1).save unless self.file_log.blank?
  end


  def extension
    File.extname(name)[1..-1]
  end


  # Creates a revision entry if the file's name has been changed
  def name_changed
    FileRevision.create_revision(self) if self.changed.index("name") && self.name 
  end
  

  def remove_empty_password
    if password.blank?
      self.password = nil
    end
  end


  # Removes the useless directory left behind when a user_file is deleted
  def remove_id_directory
    return true if Rails.env.test?
    FileUtils.remove_dir("#{Rails.root}/public/uploads/user_file/attachment/#{self.id}", 
                          :force => true)
  end


  # Sets the file's name to the name of it's attachment
  def set_name
    update_attribute(:name, attachment.file.filename)
  end


  def set_token
    update_attribute(:link_token, SecureRandom.hex(6))
  end


  # Purges all files that are older than the number of days set in application settings.
  def self.purge_old_files
    UserFile.where("created_at < ?", UserFile.purge_date).each do |user_file|
      user_file.destroy
    end
  end
  

  # Generates link for sharing files, accomodating for the application running out of a subdirectory
  def self.share_url(url)
    subdirectory = Fileship::Application.config.fileship_config['subdirectory']
    return url if subdirectory.blank?
    url = url.split("/")
    url[url.length] = url.last
    url[url.length - 2] = subdirectory
    return url.join("/")
  end
  
  
  # Returns the days_until_purge set in application settings
  def self.days_until_purge
    return Setting.find_by_name("Days until file purge").value.to_f
    
  end
  
  
  # Returns the date that all UserFiles created before will be destroyed. 
  def self.purge_date
    return Date.today.to_time_in_current_zone - UserFile.days_until_purge.days
  end
end
