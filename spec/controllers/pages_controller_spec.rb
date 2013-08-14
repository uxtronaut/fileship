require 'spec_helper'

describe PagesController do
  describe '#welcome' do
    context 'as logged in user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
      end
      
      
      it 'redirects to users home folder' do
        get :welcome
        response.should redirect_to(folders_path)
      end
    end



    #context 'as a guest' do
    #  it 'responds successfully' do
    #    session[:cas_user] = nil
    #    get :welcome
    #    response.status.should eq 200
    #  end
    #end
  end
end