class CreateUserFiles < ActiveRecord::Migration
  def change
    create_table :user_files do |t|
      t.string :attachment
      t.string :name
      t.string :link_token
      t.string :password
      t.references :folder
      t.timestamps
    end
  end
end
