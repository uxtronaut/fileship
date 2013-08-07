class AddUserIdToUserFiles < ActiveRecord::Migration

      def up
        add_column :user_files, :user_id, :integer
      end



      def down
        remove_column :user_files, :user_id
      end

end
