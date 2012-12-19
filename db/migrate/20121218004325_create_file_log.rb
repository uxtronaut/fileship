class CreateFileLog < ActiveRecord::Migration
  def change
    create_table :file_logs do |t|
      t.string :user_name
      t.string :file_name
      t.timestamps
    end
  end
end
