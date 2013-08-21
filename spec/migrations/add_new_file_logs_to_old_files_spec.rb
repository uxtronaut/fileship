# spec/migrations/add_email_at_utc_hour_to_users_spec.rb
require 'spec_helper'

migration_file_name = Dir[Rails.root.join('db/migrate/*_add_new_file_logs_to_old_files.rb')].first
require migration_file_name


describe AddNewFileLogsToOldFiles do

  # This is clearly not very safe or pretty code, and there may be a
  # rails api that handles this. I'm just going for a proof of concept here.
  def migration_has_been_run?(version)
    table_name = ActiveRecord::Migrator.schema_migrations_table_name
    query = "SELECT version FROM %s WHERE version = '%s'" % [table_name, version]
    ActiveRecord::Base.connection.execute(query).any?
  end

  let(:migration) { AddNewFileLogsToOldFiles.new }


  before do
    # You could hard-code the migration number, or find it from the filename...
    if migration_has_been_run?('20130809211922')
      # If this migration has already been in our current database, run down first
      migration.down
    end
    
    @admin = FactoryGirl.create(:admin)
    @file = FactoryGirl.create(:user_file, :user => @admin)
    ActiveRecord::Base.connection.execute("UPDATE user_files SET user_id = NULL, folder_id = 1")
    @file = UserFile.find(@file.id)
  end


  context 'before migration' do
    it 'file should have blank user_id' do      
      assert @file.user_id.should be nil
    end
    
    it 'file belong to root folder' do
      assert @file.folder_id.should eq Folder.root.id
    end
  end
    
    
  context 'after migration' do
    before do
      migration.up
      @file = UserFile.find(@file.id)
    end

    it 'assigns user id to files without one' do
      assert @file.user_id.should eq @admin.id
    end
    
    it 'assigns files without user and whos parent folder dont have a user to a new folder belonging to the first admin' do
      @folder = Folder.find_by_name("rescue_" + @admin.uid)
      assert @file.folder_id.should eq @folder.id
    end
    
    it 'gives old files new file logs' do
      @file_log = @file.file_log
      assert @file_log.downloads.should eq 0
      assert @file_log.user_id.should eq @admin.id
    end
  end
end