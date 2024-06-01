Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  devise_for :admins, controllers: {
    sessions: 'admins/sessions'
  }
  # root 'customer_client/dashboard#index'
  root 'application#landing_page'

  namespace :owner do
    resources :products do
      post 'upload_image', on: :member
    end
    resources :customers do
      resources :addresses
    end
    resources :orders,only: [:index,:update]
    resources :categories
    resources :dashboard, only: [:index]

    get 'search_user', to: 'orders#search_user'
    resources :registrations, only: [:index] do
    post 'approve', on: :member 
    end
  end


  namespace :customer_client do
    resources :dashboard, only: [:index]
    resources :cart, only: [:index]
    resources :payments, only: [:index]
    resources :refund_order, only: [] do
      post 'refund', on: :member
    end
    resources :orders, only: [:index] do
      get 'order_success', on: :collection
      get 'order_failed', on: :collection
    end
    resources :checkout, only: [:index] do
      post 'process' ,to: 'checkout#process_checkout', on: :collection
      post 'confirm' ,to: 'checkout#confirm_payment', on: :collection
     post :update_address,to: 'checkout#update_address', on: :collection
    end
    resources :cart_items, only: [:create, :destroy] do
      patch 'update_quantity', to: 'cart_items#update_quantity'
    end

    get 'order_confirmation', to: 'orders#confirmation', as: 'order_confirmation'
    get 'success', to: 'orders#success'
    get 'failed', to: 'orders#failed'

    #chatbot
    resources :chatbots

    get 'chatbot', to: 'chatbots#chatbot'
    match 'send_message', to: 'chatbots#send_message', via: [:get, :post]
    get 'get_chat_messages', to: 'chatbots#get_chat_messages'
  end



  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
