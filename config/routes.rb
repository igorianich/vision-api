Rails.application.routes.draw do
  post 'sign_in' => 'user_token#sign_in'
  post 'sign_up' => 'user_token#sign_up'
  patch 'update_me' => 'users#update'
  patch 'update_me' => 'users#update'
  # get 'requests' => 'requests#index'
  resources :skills, only: %i[index create update destroy]
  resources :services, only: %i[index create show update destroy]
  resources :requests, only: %i[index create show update destroy]
  # resources :users, only: %i[update index]

   # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
