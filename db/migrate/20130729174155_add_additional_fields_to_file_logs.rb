class AddAdditionalFieldsToFileLogs < ActiveRecord::Migration

    def up
      add_column :file_logs, :user_file_id, :integer
      add_column :file_logs, :downloads, :integer, :default => 0
      add_column :file_logs, :file_size, :integer, :default => 0
      add_column :file_logs, :deleted_at, :datetime    
      add_column :file_logs, :user_id, :integer
      remove_column :file_logs, :user_name
      remove_column :file_logs, :file_name
    end
    
    
    
    def down
      remove_column :file_logs, :user_file_id
      remove_column :file_logs, :downloads
      remove_column :file_logs, :file_size
      remove_column :file_logs, :deleted_at    
      remove_column :file_logs, :user_id
      add_column :file_logs, :user_name, :string
      add_column :file_logs, :file_name, :string
    end
  
end
