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
        
        
        
        context 'for file without file log' do
          before do
            @file = FactoryGirl.create(:user_file, :user => @user)
            @file.file_log.destroy
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
  
  
  
  
  
  describe '#update' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
        @other_user = FactoryGirl.create(:user)
      end


      context 'via json' do
        context 'for a permitted file' do
          before do
            @file = FactoryGirl.create(:user_file, :user => @user)
            post :update, {
              :id => @file.id,
              :user_file => {:name => 'testo'},
              :format => :js
            }
          end

          it 'responds successfully' do
            response.status.should eq 200
          end

          it 'sets the file name' do
            assigns(:user_file).name.should eq 'testo'
          end

          it 'renders the file partial' do
            response.should render_template(@file.folder)
          end
        end
        
        
        context 'for a permitted file without a name' do
          before do
            @file = FactoryGirl.create(:user_file, :user => @user)
            post :update, {
              :id => @file.id,
              :user_file => {:name => ''},
              :format => :js
            }
          end
          
          it 'responds with bad request error' do
            response.status.should eq 400
          end
          
          it 'renders the rename form' do
            response.should render_template('user_files/_rename_form')
          end
        end



         context 'for file without file log' do
           before do
             @file = FactoryGirl.create(:user_file, :user => @user)
             @file.file_log.destroy
             post :update, {
               :id => @file.id,
               :user_file => {:name => 'testo'},
               :format => :js
             }
           end
           
           it 'responds successfully' do
             response.status.should eq 200
           end
           
           it 'sets the file name' do
             assigns(:user_file).name.should eq 'testo'
           end
           
           it 'renders the file partial' do
             response.should render_template(@file.folder)
           end
         end


        context 'for another users file' do
          before do
            @file = FactoryGirl.create(:user_file, :user => @other_user)
          end
          it 'responds 403' do
            post :update, {
              :id => @file,
              :user_file => {:name => 'testo'},
              :format => :json
            }
            response.status.should eq 403
          end
        end
      end
    end
  end
  
  
  
  
  
  describe '#update' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
        @other_user = FactoryGirl.create(:user)
      end
  
  
      context 'via json' do
        context 'for a permitted file' do
          before do
            @file = FactoryGirl.create(:user_file, :user => @user)
            post :update, {
              :id => @file.id,
              :user_file => {:name => 'testo'},
              :format => :js
            }
          end
  
          it 'responds successfully' do
            response.status.should eq 200
          end
  
          it 'sets the file name' do
            assigns(:user_file).name.should eq 'testo'
          end
  
          it 'renders the file partial' do
            response.should render_template(@file.folder)
          end
        end
  
  
        context 'for a permitted file without a name' do
          before do
            @file = FactoryGirl.create(:user_file, :user => @user)
            post :update, {
              :id => @file.id,
              :user_file => {:name => ''},
              :format => :js
            }
          end
  
          it 'responds with bad request error' do
            response.status.should eq 400
          end
  
          it 'renders the rename form' do
            response.should render_template('user_files/_rename_form')
          end
        end
  
  
        context 'for another users file' do
          before do
            @file = FactoryGirl.create(:user_file, :user => @other_user)
          end
          it 'responds 403' do
            post :update, {
              :id => @file,
              :user_file => {:name => 'testo'},
              :format => :json
            }
            response.status.should eq 403
          end
        end
      end
    end
  end
  
  
  
  
  
  describe '#destroy' do
    context 'as a user' do
      before do
        @user = FactoryGirl.create(:user)
        User.stubs(:find_or_import).returns(@user)
        RubyCAS::Filter.fake(@user.uid)
        session[:cas_user] = @user.uid
        @other_user = FactoryGirl.create(:user)
      end
  
  
      context 'via json' do
        context 'for a permitted file' do
          before do
            @file = FactoryGirl.create(:user_file, :user => @user)
            @folder = @file.folder
            delete :destroy, {
              :id => @file.id,
              :format => :js
            }
          end
  
          it 'deletes file and redirects to folder' do
            response.should render_template(@folder)
          end
        end
  
  
        context 'for another users file' do
          before do
            @file = FactoryGirl.create(:user_file, :user => @other_user)
          end
          
          it 'responds 403' do
            delete :destroy, {
              :id => @file,
              :format => :json
            }
            response.status.should eq 403
          end
        end
      end
    end
  end
end