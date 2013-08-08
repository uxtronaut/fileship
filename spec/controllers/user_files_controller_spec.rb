require 'spec_helper'

describe UserFilesController do
  describe '#show' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        @file = FactoryGirl.create(:user_file)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        get :show, :id => @file.id
        
      end

      it 'should send the file' do
        response.status.should eq 200
      end
    end
    
    
    context 'as a guest' do
      before do
        @file = FactoryGirl.create(:user_file)
        get :show, :id => @file.id
        
      end

      it 'should send the file' do
        response.status.should eq 200
      end
    end
  end
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  
  describe '#purge_test_uploads' do
    context 'as an admin' do
      before do
        @user = FactoryGirl.create(:admin)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
      end

      it 'redirects to welcome page' do
        get :purge_test_uploads
        response.should redirect_to welcome_path
      end
    end
  end
end