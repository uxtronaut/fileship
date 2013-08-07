require 'spec_helper'

describe UserFilesController do
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