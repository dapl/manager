Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {sign_in: 'login', sign_out: 'logout'}
 
  resources :users do
    post :password, on: :member
    post :disable, on: :member
    post :enable, on: :member

    post '/groups', to: "users#add_group"
    delete '/groups/:group', to: "users#remove_group"

    post '/keys', to: "users#add_key"
    delete '/keys/:key_name', to: "users#remove_key"
  end

  resources :groups do
    post '/users', to: "groups#add_user"
    delete '/users/:user', to: "groups#remove_user"
  end

  root 'home#index'
end
