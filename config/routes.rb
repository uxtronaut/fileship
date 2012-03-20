Fileship::Application.routes.draw do

  resources :folders do
    resources :folders
    resources :user_files
  end

  resources :user_files

  resources :feedback, :only => [:new, :create]

  match 'signout', :controller => :application, :action => :signout, :via => :get

  match 'welcome', :controller => :pages, :action => :welcome, :via => :get
  match 'help', :controller => :pages, :action => :help, :via => :get
  match 'policy', :controller => :pages, :action => :policy, :via => :get

  root :to => 'pages#welcome'

end
