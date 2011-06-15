Openauthenticator::Application.routes.draw do
  resources :users do
    resources :account_token
    resources :personal_key
  end

  match '/users/new/check_email', :to => 'users#check_email'
  match '/users/new/check_login', :to => 'users#check_login'
end
