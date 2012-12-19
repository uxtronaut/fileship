class FileLog < ActiveRecord::Base

  def self.create_log(user_file)
    FileLog.create(:user_name => user_file.folder.user.uid, :file_name => user_file.name)
  end
end