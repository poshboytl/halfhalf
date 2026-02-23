Rails.application.routes.draw do
  # Health check
  get "up" => "rails/health#show", as: :rails_health_check

  # Auth
  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"
  get "signup", to: "users#new"
  post "signup", to: "users#create"

  # Main app - Conversations are the main UI
  root "conversations#index"

  # Projects and Conversations
  resources :projects do
    resources :conversations, shallow: true
  end

  # Quick new conversation (without project context)
  post "conversations", to: "conversations#create", as: :quick_conversation

  # Gateway config (legacy, keep for now)
  resources :gateway_configs, only: [:new, :create, :edit, :update, :destroy]

  # Messages within conversation
  resources :conversations, only: [] do
    resources :messages, only: [:create]
  end
end
