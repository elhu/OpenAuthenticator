Openauthenticator::Application.routes.draw do
  resources :users do
    resources :account_token
    resources :personal_key
    resources :auth_log
  end

  match '/authenticate', :to => 'auth#authenticate', :via => "post"
  match '/sync', :to => 'auth#sync', :via => "get"
  match '/session_auth', :to => 'auth#session_auth', :via => "post"

  match '/users/new/check_email', :to => 'users#check_email'
  match '/users/new/check_login', :to => 'users#check_login'
end
