Fileship::Application.routes.draw do
  resources :users

  resources :folders do
    resources :folders
    resources :user_files
  end

  resources :user_files

  match 'signout', :controller => :application, :action => :signout, :via => :get
  match 'welcome', :controller => :pages, :action => :welcome, :via => :get

  root :to => 'pages#welcome'

end
