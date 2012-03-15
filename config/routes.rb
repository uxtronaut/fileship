Fileship::Application.routes.draw do
  resources :users

  resources :folders
  resources :user_files

  root :to => 'pages#welcome'

end
