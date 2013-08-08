require 'spec_helper'
require 'carrierwave/test/matchers'



describe UserFilesController do
  include CarrierWave::Test::Matchers
  describe '#show' do
    context 'as an admin' do
      before do
        @user = FactoryGirl.create(:admin)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
      end
      
      
      context 'for own file' do
        context 'for unprotected file' do
          before do
            @file = FactoryGirl.create(:user_file, :user => @user)
            get :show, :id => @file.id
          end
        
        
          it 'should send the file' do
            response.status.should eq 200
          end
        end
        
        
        
        context 'for password protected file' do
          before do
            @file = FactoryGirl.create(:user_file, :password => 'test', :user => @user)
            get :show, :id => @file.id
          end
        
        
          it 'should send the file' do
            response.status.should eq 200
          end
        end
      end
      
      
      
      context 'for anothers file' do
        context 'for unprotected file' do
          before do
            @file = FactoryGirl.create(:user_file)
            get :show, :id => @file.id
          end
        
        
          it 'should send the file' do
            response.status.should eq 200
          end
        end
        
        
        
        context 'for password protected file' do
          before do
            @file = FactoryGirl.create(:user_file, :password => 'test')
            get :show, :id => @file.id
          end
        
        
          it 'should redirect to password entry form' do
            response.should redirect_to(enter_password_user_file_path(@file))
          end
        end
      end
    end
    
    
    
    context 'as a guest' do
      context 'for unprotected file' do
        before do
          @file = FactoryGirl.create(:user_file)
          get :show, :id => @file.id
        end
        
      
        it 'should send the file' do
          response.status.should eq 200
        end
      end
      
      
      
      context 'for password protected file' do
        before do
          @file = FactoryGirl.create(:user_file, :password => 'test')
          get :show, :id => @file.id
        end
        
      
        it 'should redirect to password entry form' do
          response.should redirect_to(enter_password_user_file_path(@file))
        end
      end
    end
  end
  
  
  
  
  
  describe '#check_password' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        @file = FactoryGirl.create(:user_file, :password => 'test')
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
      end
      
      
      it 'should send file if password is correct' do
        get :check_password, :id => @file.id, :user_file => {:password => 'test'}
        response.status.should eq 200
      end
      
      
      it 'should render password form if password is incorrect' do
        get :check_password, :id => @file.id, :user_file => {:password => 'testo'}
        response.should render_template('user_files/enter_password')
      end
    end
  end
  
  
  
  
  
  describe '#new' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
      end
      
      
      it 'should get page' do
        get :new, :folder_id => @user.home_folder.id
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


      context 'via json' do
        context 'for a valid file' do
          it 'responds successfully' do
            post :create, {
              :folder_id => @user.home_folder.id,
              :qqfile => Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/files/test.png"),'image/png'),
              :format => :json
            }
            response.status.should eq 200
          end
        end
        
        
        context 'for invalid file' do
          it 'shows errors preventing upload' do
            post :create, {
              :folder_id => @user.home_folder.id,
              :qqfile => nil,
              :format => :json
            }
            assert !assigns(:user_file).errors.blank?
            response.status.should eq 200
          end
        end
      end
      
      
      
      context 'via html' do
        context 'for a valid file' do
          it 'responds successfully' do
            post :create, {
              :folder_id => @user.home_folder.id,
              :user_file => {
                :attachment => Rack::Test::UploadedFile.new(File.join(Rails.root, "spec/files/test.png"),'image/png')
              }
            }
            response.should redirect_to(folder_path(@user.home_folder.id))
          end
        end
        
        
        context 'for invalid file' do
          it 'renders new file form' do
            post :create, {
              :folder_id => @user.home_folder.id,
              :user_file => {
                :attachment => nil
              }
            }
            response.should render_template('user_files/new')
          end
        end
      end
    end
  end
  
  
  
  
  
  
  describe '#purge_test_uploads' do
    context 'as an admin' do
      before do
        @user = FactoryGirl.create(:admin)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
      end

      it 'redirects to welcome page' do
        get :purge_test_uploads
        response.should redirect_to welcome_path
      end
    end
  end
end