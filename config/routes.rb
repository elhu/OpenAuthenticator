Openauthenticator::Application.routes.draw do
  get "personal_key/new"

  get "personal_key/create"

  get "personal_key/index"

  get "personal_key/show"

  get "personal_key/delete"

  get "account_token/create"

  get "account_token/update"

  get "account_token/delete"

  resources :users

  match "/register" => "users#new"
end
