Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Auth
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "signup", to: "users#new"
  post "signup", to: "users#create"

  # Main app
  root "chat#index"

  # Gateway config
  resources :gateway_configs, only: [:new, :create, :edit, :update, :destroy]
end
