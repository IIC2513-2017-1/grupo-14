Rails.application.routes.draw do
  get 'sessions/new'

  resources :bets do
    resource :winners
    resources :participations, only: [:new, :create]
    collection do
      get :paginate
      get :partial_bet_show
    end
  end

  resources :participations, only: [:destroy]
  
  resources :choices
  resources :users do
    resources :friendship_requests, only: [:create]
    resources :friendships, only: [:create]
    member do
      get :sync_calendar
      get :redirect
      get :callback
    end
  end

  resources :friendship_requests, only: [:destroy]
  resources :friendships, only: [:destroy]

  resource :session, only: [:new, :create, :destroy]

  # post "api/v1/user" => "api#v1#users#create"
  namespace :api do
    namespace :v1 do
      resources :users, only: [:index, :show, :create]
      resources :bets, only: [:index, :show, :create, :destroy] do
        resources :participations, only: [:create]
      end
      resources :participations, only: [:destroy]
      resources :choices, only: [:create, :destroy]
    end
  end

  get 'home/index'
  root 'home#index'

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
