require 'spec_helper'

describe UserFile do
  describe "validations" do
    it "should require a folder_id" do
      user_file = FactoryGirl.build(:user_file, :folder => nil)
      user_file.should_not be_valid
      user_file.should have(1).error_on(:folder_id)
    end

    it "should require an attachment" do
      user_file = FactoryGirl.build(:user_file, :attachment => nil)
      user_file.should_not be_valid
      user_file.should have(1).error_on(:attachment)
    end
  end


  describe "#extension" do
    it "returns the file's extension" do
      user_file = FactoryGirl.create(:user_file)
      user_file.extension.should == 'png'
    end
  end


  describe "#purge_old_files" do
    it "should remove all files older than the pre-defined number of days" do
      Fileship::Application.config.fileship_config['days_until_purge'] = 1
      # creates user_file one day before the purge date. Should be purged
      user_file = FactoryGirl.create(:user_file, :created_at => (Date.today.to_time_in_current_zone - (UserFile.days_until_purge + 1).days) )
      UserFile.all.should_not be_empty
      UserFile.where("created_at < ?", UserFile.purge_date).should_not be_empty
      UserFile.purge_old_files
      UserFile.all.should be_empty
    end
    
    it "should not remove files that aren't older than the pre-defined number of days" do
      # creates user_file right now. Should not be purged.
      user_file = FactoryGirl.create(:user_file)
      # creates user_file on the purge date. Should not be purged.
      user_file_2 = FactoryGirl.create(:user_file, :created_at => (Date.today.to_time_in_current_zone - UserFile.days_until_purge.days) )
      UserFile.all.should_not be_empty
      UserFile.where("created_at < ?", UserFile.purge_date).should be_empty
      UserFile.purge_old_files
      UserFile.all.include?(user_file).should eq true
      UserFile.all.include?(user_file_2).should eq true
    end
  end
end