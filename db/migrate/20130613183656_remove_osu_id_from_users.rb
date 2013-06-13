class RemoveOsuIdFromUsers < ActiveRecord::Migration
  def up
    remove_column :users, :osu_id
  end

  def down
    add_column :users, :osu_id, :string
  end
end