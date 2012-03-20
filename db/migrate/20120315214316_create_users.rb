class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.boolean :is_admin
      t.string :uid
      t.string :first_name
      t.string :last_name
      t.string :osu_id
      t.string :ldap_identifier
      t.timestamps
    end
  end
end
