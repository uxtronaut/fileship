# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  email           :string(255)
#  is_admin        :boolean
#  uid             :string(255)
#  first_name      :string(255)
#  last_name       :string(255)
#  ldap_identifier :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

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



  describe '#home_folder' do
    it "returns the user's home folder if it exists" do
      user = FactoryGirl.create(:user)
      user.home_folder.should_not be_nil
      user.home_folder.name.should eq(user.uid)
      user.home_folder.parent.should eq(Folder.root)
    end
    
    it "creates a new home folder if one doesn't exist" do
      user = FactoryGirl.create(:user)
      user.home_folder.destroy
      user.home_folder.should_not be_nil
      user.home_folder.name.should eq(user.uid)
      user.home_folder.parent.should eq(Folder.root)
    end
  end



  describe '#name' do
    it "returns the user's full name" do
      user = FactoryGirl.build(:user)
      user.name.should eq("#{user.first_name} #{user.last_name}")
    end
  end
  
  
  
  describe '#find_or_import' do    
    context 'for an existing user' do
      before do 
        @user = FactoryGirl.create(:user)
      end
      
      it 'returns the user' do
        User.find_or_import(@user.uid).should eq @user
        User.all.length.should eq 1
      end
    end
    
    
    context 'for a new user' do
      before do
        @test_uid = Fileship::Application.config.ldap['test_uid']
      end
      
      it 'imports the user form ldap' do
        unless @test_uid.blank?
          User.find_or_import(@test_uid).should eq User.last
          User.all.length.should eq 1
        end
      end
    end
  end
  
  
  
end
