require 'spec_helper'

describe FeedbackController do  
  
  describe '#new' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid  
      end

      it "gets the feedback form" do        
        get :new        
        response.status.should eq 200
      end
    end
  end


  describe '#create' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid      
      end

      it 'saves valid feedback and redirects to thanks page' do
        post :create, {
          :feedback => {
            :subject => "test",
            :description => "test"
          }
        }
        response.should redirect_to(thanks_feedback_index_path)
      end
      
      it 'redners new view if feedback was invalid' do
        post :create, {
          :feedback => {
            :subject => "",
            :description => ""
          }
        }
        response.should render_template("feedback/new")
      end
    end
  end
end