require 'spec_helper'

describe User do
  describe 'validations' do
    it 'requires a uid' do
      user = FactoryGirl.build(:user, :uid => nil)
      user.should_not be_valid
      user.should have(1).error_on(:uid)
    end

    it 'requires an email' do
      user = FactoryGirl.build(:user, :email => nil)
      user.should_not be_valid
      user.should have(2).error_on(:email) # 2 errors as email can't be blank OR invalid
    end

    it 'requires a unique email' do
      user_1 = FactoryGirl.create(:user)
      user_2 = FactoryGirl.build(:user, :email => user_1.email)
      user_2.should_not be_valid
      user_2.should have(1).error_on(:email)
    end

    it 'requires a unique uid' do
      user_1 = FactoryGirl.create(:user)
      user_2 = FactoryGirl.build(:user, :uid => user_1.uid)
      user_2.should_not be_valid
      user_2.should have(1).error_on(:uid)
    end
  end

  describe '#after_import' do
    before do
      FactoryGirl.create(:root_folder)
      @user = FactoryGirl.build(:user)
      @user.after_import
    end

    it "saves the user" do
      @user.should_not be_new_record
    end

    it "creates the user's home folder" do
      @user.home_folder.should_not be_nil
      @user.home_folder.name.should eq(@user.uid)
    end
  end

  describe '#home_folder' do
    it "returns the user's home folder" do
      FactoryGirl.create(:root_folder)
      user = FactoryGirl.create(:user)
      user.home_folder.should_not be_nil
      user.home_folder.name.should eq(user.uid)
      user.home_folder.parent.should eq(Folder.root)
    end
  end

  describe '#full_name' do
    it "returns the user's full name" do
      user = FactoryGirl.build(:user)
      user.full_name.should eq("#{user.first_name} #{user.last_name}")
    end
  end
end