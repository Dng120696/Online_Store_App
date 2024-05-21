Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }
  root 'home#index'

  namespace :owner do
    resources :products
    resources :customers do
      resources :addresses
    end
    resources :orders
    resources :categories
    resources :dashboard, only: [:index]

  end
  namespace :customer_client do
    resources :dashboard, only: [:index]
    resource :cart, only: [:show]
    resources :cart_items, only: [:create, :destroy]
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
