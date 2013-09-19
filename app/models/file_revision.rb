# == Schema Information
#
# Table name: file_revisions
#
#  id           :integer          not null, primary key
#  file_name    :string(255)
#  user_file_id :integer
#  file_log_id  :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class FileRevision < ActiveRecord::Base

  attr_accessible :file_name, :user_file_id, :file_log_id

  belongs_to :user_file
  belongs_to :file_log
  
  validates_presence_of :file_name, :user_file_id, :file_log_id

  # Creates a revision entry for the file
  def self.create_revision(user_file)
    return if user_file.file_log.blank?
    FileRevision.create(:user_file_id => user_file.id, :file_name => user_file.name, :file_log_id => user_file.file_log.id)
  end
end
