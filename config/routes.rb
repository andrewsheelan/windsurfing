Rails.application.routes.draw do
  mount ActionCable.server => "/cable"
  # Authentication routes
  devise_for :users

  # Root path
  root "products#index"

  # Product routes
  resources :products

  # Cart routes
  resource :cart
  resources :cart_items

  # Order routes
  resources :orders

  # Message routes
  resources :messages, only: [ :index, :create ]

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
