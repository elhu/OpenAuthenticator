Openauthenticator::Application.routes.draw do

  resources :personal_key, :only => [:new, :create, :index, :show, :delete]

  resources :account_token, :only => [:create, :update, :delete]

  resources :users

  match '/users/new/check_email', :to => 'users#check_email'
  match '/users/new/check_login', :to => 'users#check_login'

  match "/register" => "users#new"
end
