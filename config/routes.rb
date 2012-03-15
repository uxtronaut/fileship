Fileship::Application.routes.draw do
  resources :folders
  resources :user_files

  root :to => 'pages#welcome'

end
