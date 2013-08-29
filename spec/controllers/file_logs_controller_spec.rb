require 'spec_helper'

describe FileLogsController do  
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
        @admin = FactoryGirl.create(:admin)
        @file = FactoryGirl.create(:user_file, :user => @admin)
        @other_file = FactoryGirl.create(:user_file)
        User.stubs(:find_or_import).returns(@admin)
        RubyCAS::Filter.fake(@admin.uid)
        session[:cas_user] = @admin.uid
      end
    
      
      
      context 'without a search' do
        before do
          get :index  
        end
        
        
        it 'responds successfully' do
          response.status.should eq 200
        end
      end
      
      
      
      context 'with a search for file name' do
        before do
          get :index, {
            :search => {
              :user => @admin.name,
              :name => @file.name
            }
          }
        end
        
        
        it 'responds successfully' do
          response.status.should eq 200
        end
      end
    end
  end
end