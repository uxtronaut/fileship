class UserFile < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader

  belongs_to :folder

  validates_presence_of :attachment
  validates_presence_of :folder_id

  def extension
    File.extname(attachment.file.filename  )[1..-1]
  end
end
