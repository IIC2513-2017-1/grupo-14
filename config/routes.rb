Rails.application.routes.draw do
  get 'sessions/new'

  resources :bets do
    resource :winners
  end
  resources :participations
  resources :choices
  resources :users do
  	resources :friendship_requests, only: [:create]
  	resources :friendships, only: [:create]
  end

  resources :friendship_requests, only: [:destroy]
  resources :friendships, only: [:destroy]

  resource :session, only: [:new, :create, :destroy]

  get 'home/index'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
