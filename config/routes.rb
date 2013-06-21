Fileship::Application.routes.draw do

  resources :settings do
    collection do
      post :update_settings
    end
  end


  resources :folders do
    resources :folders
    resources :user_files
  end


  resources :user_files do
    collection do
      get :purge_test_uploads
    end
    member do
      put :email
      get :enter_password
      put :check_password
      post :share
    end
  end


  resources :feedback do
    collection do
      get :thanks
    end
  end

  match 'signout', :controller => :application, :action => :signout, :via => :get

  match 'welcome', :controller => :pages, :action => :welcome, :via => :get
  match 'help', :controller => :pages, :action => :help, :via => :get

  match ':link_token', :controller => :user_files, :action => :show, :via => :get

  root :to => 'pages#welcome'

end
