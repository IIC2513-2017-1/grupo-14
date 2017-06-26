Rails.application.routes.draw do
  get 'sessions/new'

  resources :bets do
    resource :winners
    resources :participations, only: [:new, :create]
  end

  resources :participations, only: [:destroy]
  
  resources :choices
  resources :users do
  	resources :friendship_requests, only: [:create]
  	resources :friendships, only: [:create]
  end

  resources :friendship_requests, only: [:destroy]
  resources :friendships, only: [:destroy]

  resource :session, only: [:new, :create, :destroy]

  get '/redirect', to: 'google_token#redirect', as: 'redirect'
  get '/callback', to: 'google_token#callback', as: 'callback'
  get '/calendars', to: 'google_token#calendars', as: 'calendars'
  get '/events', to: 'google_token#events', as: 'events'
  get '/new_event', to: 'google_token#new_event', as: 'new_event'

  get 'home/index'
  root 'home#index'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
