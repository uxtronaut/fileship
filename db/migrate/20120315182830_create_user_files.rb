class CreateUserFiles < ActiveRecord::Migration
  def change
    create_table :user_files do |t|
      t.string :attachment
      t.references :folder
      t.timestamps
    end
  end
end
