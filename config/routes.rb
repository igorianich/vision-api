Rails.application.routes.draw do
  post 'sign_in' => 'user_token#sign_in'
  get 'users' => 'users#index'
  get 'users/:id' => 'users#show'
  post 'sign_up' => 'users#create'
  patch 'update_me' => 'users#update'
  # get 'requests' => 'requests#index'
  # get 'responses' => 'responses#index'

  resources :skills, only: %i[index create show update destroy]
  resources :services, only: %i[index create show update destroy]
  resources :requests, only: %i[index create show update destroy]
  resources :responses, only: %i[index create show]
  patch 'requests/:id/decline' => 'requests#decline'
  resources :payments, only: %i[index show]
  resources :reviews, only: %i[index create show update destroy]
  # resources :users, only: %i[update index]

   # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
