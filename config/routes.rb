Openauthenticator::Application.routes.draw do

  get "pages/home"

  get "pages/about"

  get "pages/faq"

  get "pages/contact"

  resources :users do
    resources :account_token
    resources :personal_key
  end

  match '/users/new/check_email', :to => 'users#check_email'
  match '/users/new/check_login', :to => 'users#check_login'

  match '/', :to => 'pages#home'
  match '/contact', :to => 'pages#contact'
  match '/faq', :to => 'pages#faq'
  match '/about', :to => 'pages#about'

  match "/register" => "users#new"

  root :to => 'pages#home'
end
