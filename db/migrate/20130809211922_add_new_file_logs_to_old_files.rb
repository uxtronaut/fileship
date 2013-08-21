class AddNewFileLogsToOldFiles < ActiveRecord::Migration
  def up
    FileLog.all.each do |file_log|
      file_log.destroy
    end
    
    admin = User.where(:is_admin => true).first
    folder = Folder.find_by_name("rescue_" + admin.uid) unless admin.blank?
    unless admin.blank? || folder
      folder = Folder.create(:name => "rescue_" + admin.uid, :user_id => admin.id)
      folder.parent = Folder.root
      folder.save
    end
    
    UserFile.all.each do |user_file|
      if user_file.folder.user_id.blank?
        if admin
          user_file.update_attributes(:folder_id => folder.id, :user_id => admin.id)
        else
          user_file.destroy
        end
        next
      end
      user_file.update_attributes(:user_id => user_file.folder.user_id)
      FileLog.create_log(user_file)
      file_log = user_file.file_log
      file_log.created_at = user_file.created_at
      file_log.save
      attachment_name = user_file.attachment.file.filename
      FileRevision.create(:user_file_id => user_file.id, :file_log_id => file_log.id, :file_name => attachment_name) if user_file.name != attachment_name
      FileRevision.create_revision(user_file)
    end
  end
  
  
  
  def down
    
  end
end
