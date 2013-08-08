require 'spec_helper'

describe UsersController do
  describe '#index' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
        get :index
      end


      it "responds with permission denied" do
        response.status.should eq 403
      end
      
      
      it 'renders the permission denied page' do
        response.should render_template("pages/403")
      end
    end



    context 'as an admin' do
      before do
        @user = FactoryGirl.create(:admin)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
        get :index
      end
    
    
      it 'responds successfully' do
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






  describe '#add_admin' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        @user_to_add = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
        post :add_admin, {
          :user => {:id => @user_to_add}
        }
      end
      
      
      it "responds with permission denied" do
        response.status.should eq 403
      end
      
      
      it 'renders the permission denied page' do
        response.should render_template("pages/403")
      end
    end
    
    
    
    context 'as an admin' do
      before do
        @user = FactoryGirl.create(:admin)
        @user_to_add = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
        post :add_admin, {
          :user => {:id => @user_to_add}
        }
      end
      
      
      it 'responds successfully with redirect' do
        response.status.should eq 302
      end
      
      
      it 'redirects to users path' do
        response.should redirect_to users_path
      end
    end
  end
end