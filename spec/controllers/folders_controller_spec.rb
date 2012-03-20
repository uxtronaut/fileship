require 'spec_helper'

describe FoldersController do
  describe '#index' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
      end

      it "redirects to the user's home folder" do
        get :index
        response.should redirect_to @user.home_folder
      end
    end

    context 'as an admin' do
      before do
        @user = FactoryGirl.create(:admin)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
      end

      it 'redirects to the root folder' do
        get :index
        response.should redirect_to Folder.root
      end
    end

    context 'as a guest' do
      it 'redirects to the login path' do
        get :index
        response.should redirect_to RubyCAS::Filter.login_url(controller)
      end
    end
  end

  describe '#show' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
      end

      context 'for a permitted folder' do
        before do
          @folder = FactoryGirl.create(:folder, :user => @user)
          get :show, :id => @folder.id
        end

        it 'responds successfully' do
          response.status.should eq 200
        end

        it 'renders the folder show template' do
          response.should render_template('folders/show')
        end

        it 'assigns the correct folder' do
          assigns(:folder).should eq @folder
        end
      end

      context 'for an unpermitted folder' do
        before do
          @folder = FactoryGirl.create(:folder, :user => FactoryGirl.create(:user))
          get :show, :id => @folder.id
        end

        it 'responds 403' do
          response.status.should eq 403
        end
      end

      context 'for the root folder' do
        it 'responds 403' do
          root = Folder.root
          get :show, :id => root.id
          response.status.should eq 403
        end
      end
    end

    context 'as an admin' do
      before do
        @user = FactoryGirl.create(:admin)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
      end

      context "for the admin's folder" do
        it 'responds successfully' do
          @folder = FactoryGirl.create(:folder, :user => @user)
          get :show, :id => @folder.id
          response.status.should eq 200
        end
      end

      context "for another user's folder" do
        it 'responds successfully' do
          @folder = FactoryGirl.create(:folder, :user => FactoryGirl.create(:user))
          get :show, :id => @folder.id
          response.status.should eq 200
        end
      end

      context "for the root folder" do
        it 'should render the root folder' do
          root = Folder.root
          get :show, :id => root.id
          response.status.should eq 200
        end
      end
    end

    context 'as a guest' do
      it 'redirects to the login path' do
        @folder = FactoryGirl.create(:folder)
        get :show, :id => @folder.id
        response.should redirect_to RubyCAS::Filter.login_url(controller)
      end
    end
  end

  describe '#create' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        @home_folder = @user.home_folder
        @home_folder.update_attribute(:user, @user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
      end

      context 'via json' do
        context 'for a permitted parent folder' do
          before do
            post :create, {
              :folder_id => @user.home_folder.id,
              :folder => {:name => 'testo'},
              :format => :json
            }
          end

          it 'responds successfully' do
            response.status.should eq 200
          end

          it 'sets the user_id' do
            assigns(:folder).user.should eq @user
          end

          it 'renders the folder partial' do
            response.should render_template('folders/_folder')
          end
        end

        context 'for an unpermitted parent folder' do
          it 'responds 403' do
            post :create, {
              :folder_id => Folder.root.id,
              :folder => {:name => 'testo'},
              :format => :json
            }
            response.status.should eq 403
          end
        end
      end

      context 'via html' do
        before do
          post :create, {
            :folder_id => @user.home_folder.id,
            :folder => {:name => 'testo'}
          }
        end

        it 'responds successfully' do
          response.status.should eq 302
        end

        it 'renders the folder template' do
          response.should redirect_to assigns(:parent_folder)
        end
      end

    end
  end
end