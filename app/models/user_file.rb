class UserFile < ActiveRecord::Base
  mount_uploader :attachment, AttachmentUploader

  belongs_to :folder

  validates_presence_of :attachment
  validates_presence_of :folder_id
  #validates_format_of :attachment_file_name, :with => /^[^\/\\\?\*:|"<>]+$/, :message => I18n.t(:invalid_characters, :scope => [:activerecord, :errors, :messages])

  def extension
    File.extname(attachment.file.filename  )[1..-1]
  end
end
