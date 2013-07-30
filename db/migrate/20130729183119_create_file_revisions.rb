class CreateFileRevisions < ActiveRecord::Migration
  def change
    create_table :file_revisions do |t|
      t.string :file_name
      t.integer :user_file_id
      t.integer :file_log_id
      t.timestamps
    end
  end
end
