Rails.application.routes.draw do
  get 'admin/index'
  get 'admin/update'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  telegram_webhook TelegramWebhookController
  resources :players
  resources :admins, only: %i[ :index, :update]
  resources :venues, only: [:index]
  root to: "auth#show"
end
