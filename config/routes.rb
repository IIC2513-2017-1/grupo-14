Rails.application.routes.draw do
  resources :bets
  resources :participations
  resources :choices
  resources :users
  
  get 'home/index'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
