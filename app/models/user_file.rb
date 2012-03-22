class UserFile < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader

  belongs_to :folder

  validates_presence_of :attachment
  validates_presence_of :folder_id
  validates_presence_of :name, :on => :update

  after_create :set_name

  def extension
    File.extname(name)[1..-1]
  end

  def set_name
    update_attribute(:name, attachment.file.filename)
  end

end
