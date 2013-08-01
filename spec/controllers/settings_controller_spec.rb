require 'spec_helper'

describe SettingsController do
  before do
    SeedFu.seed
    @setting_hash = {"setting0"=>{"value"=>"30", "id"=>"1", "name"=>"Days until file purge"}, "setting1"=>{"value"=>"60", "id"=>"2", "name"=>"Days until log purge"}, "setting2"=>{"value"=>"http://oregonstate.edu/osuhomepage/regions/top-hat/current/images/osu-tag.png", "id"=>"3", "name"=>"Logo image path"}, "setting3"=>{"value"=>"http://oregonstate.edu/osuhomepage/regions/top-hat/current/images/osu-tag.png", "id"=>"4", "name"=>"Logo url"}, "setting4"=>{"value"=>"http://google.com", "id"=>"5", "name"=>"Policy path"}, "setting5"=>{"value"=>"", "id"=>"6", "name"=>"Stylesheet path"}}
  end
  
  
  
  describe '#index' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)        
      end

      it "redirects to the user's home folder" do        
        get :index        
        response.status.should eq 403
      end
    end

    context 'as an admin' do
      before do
        @user = FactoryGirl.create(:admin)        
        User.stubs(:find_or_import).returns(@user)        
        RubyCAS::Filter.fake(@user.uid)        
      end

      it 'lets admins view app settings' do
        get :index
        response.status.should eq 200
      end
    end

    context 'as a guest' do
      it 'redirects to the login path' do
        get :index
        response.status.should eq 302
      end
    end
  end


  describe '#update_settings' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
      end

      it 'responds 403' do
        post :update_settings, {
          "settings"=> @setting_hash
        }
        response.status.should eq 403
      end
    end
    
    context 'as an admin' do
      before do
        @user = FactoryGirl.create(:admin)        
        User.stubs(:find_or_import).returns(@user)        
        RubyCAS::Filter.fake(@user.uid)        
      end
      
      it 'updates and redirects to index' do
        post :update_settings, {
          "settings"=> @setting_hash
        }
        response.should redirect_to settings_path
      end
    end
  end
end