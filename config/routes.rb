Rails.application.routes.draw do
  get 'sessions/new'

  resources :bets
  resources :participations
  resources :choices
  resources :users
  resource :session, only: [:new, :create, :destroy]
  
  get 'home/index'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
