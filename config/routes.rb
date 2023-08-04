Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  telegram_webhook TelegramWebhookController
  resources :players
  root to: "players#index"
end
