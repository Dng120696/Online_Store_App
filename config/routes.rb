Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
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
    get 'search_user', to: 'orders#search_user'

  end
  namespace :customer_client do
    resources :dashboard, only: [:index]
    resources :cart, only: [:index]
    resources :checkout, only: [:index] do
      post 'process' ,to: 'checkout#process_checkout', on: :collection
      post 'confirm' ,to: 'checkout#confirm_payment', on: :collection
    end
    resources :cart_items, only: [:create, :destroy]

    resources :orders

    get 'order_confirmation', to: 'orders#confirmation', as: 'order_confirmation'
    get 'success', to: 'orders#success'
    get 'failed', to: 'orders#failed'
    get 'gcash_payment',to: 'gcash_payment#gcash_payment'
    get 'card_payment',to: 'card_payment#card_payment'

    post '/webhooks/paymongo_webhook', to: 'webhooks#paymongo_webhook'
  end

  get 'chatbot/create_customer', to: 'chatbot#create_customer'
  post 'chatbot/create_customer', to: 'chatbot#create_customer'
  get 'chatbot/send_message', to: 'chatbot#send_message'
  post 'chatbot/send_message', to: 'chatbot#send_message'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
