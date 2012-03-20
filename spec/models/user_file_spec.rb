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
end