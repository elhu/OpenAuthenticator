Openauthenticator::Application.routes.draw do
  resources :users do
    resources :account_token
    resources :personal_key
    resources :auth_log
    resources :sync_token do
      member do
        get 'account_sync'
      end
    end
  end

  match '/authenticate', :to => 'auth#authenticate', :via => "post"
  match '/sync', :to => 'auth#sync', :via => "get"
  match '/session_auth', :to => 'auth#session_auth', :via => "post"
  # match '/account_sync', :to => 'sync_token#account_sync', :via => "get"

  match '/users/new/check_email', :to => 'users#check_email'
  match '/users/new/check_login', :to => 'users#check_login'
end
