Openauthenticator::Application.routes.draw do

  get "pages/home"

  get "pages/about"

  get "pages/faq"

  get "pages/contact"

  resources :personal_key, :only => [:new, :create, :index, :show, :delete]

  resources :account_token, :only => [:create, :update, :delete]

  resources :users

  match '/users/new/check_email', :to => 'users#check_email'
  match '/users/new/check_login', :to => 'users#check_login'

  match '/', :to => 'pages#home'
  match '/contact', :to => 'pages#contact'
  match '/faq', :to => 'pages#faq'
  match '/about', :to => 'pages#about'

  match "/register" => "users#new"

  root :to => 'pages#home'
end
