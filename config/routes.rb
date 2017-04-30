Rails.application.routes.draw do
  resources :participations
  get 'home/index'

  resources :bets
  resources :choices
  resources :users

  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
