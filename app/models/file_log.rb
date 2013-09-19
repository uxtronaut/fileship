# == Schema Information
#
# Table name: file_logs
#
#  id           :integer          not null, primary key
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_file_id :integer
#  downloads    :integer          default(0)
#  file_size    :integer          default(0)
#  deleted_at   :datetime
#  user_id      :integer
#

# Fileship
# Copyright (C) 2012 Oregon State University
#
#

class FileLog < ActiveRecord::Base

  attr_accessible :user_id, :user_file_id, :downloads, :file_size, :deleted_at
  
  belongs_to :user
  belongs_to :user_file
  
  has_many :file_revisions, :dependent => :destroy
  
  validates_presence_of :user_file_id, :user_id

  delegate :name, :to => :user, :allow_nil => true, :prefix => true



  # Creates a new file log
  def self.create_log(user_file)
    if user_file.user_id
      user_id = user_file.user_id
    else
      user_id = user_file.folder.user_id
    end
    FileLog.create(:user_id => user_id, :user_file_id => user_file.id, :file_size => user_file.attachment.file.size)
  end

  
  # Purges all logs that are older than the number of days set in application settings.
  def self.purge_old_logs
    FileLog.where("created_at < ?", FileLog.purge_date).each do |file_log|
      file_log.destroy
    end
  end
  
  
  # Returns the days_until_purge set in application settings
  def self.days_until_purge
    return Setting.find_by_name("Days until log purge").value.to_f
  end
  
  
  # Returns the date that all FileLogs created before will be destroyed. 
  def self.purge_date
    return Date.today.to_time_in_current_zone - FileLog.days_until_purge.days
  end
end
