Rails.application.routes.draw do
  resources :bets
  resources :participations
  get 'home/index'

  resources :choices
  resources :users

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
