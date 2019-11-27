Rails.application.routes.draw do
  devise_for :users
  root "wows#index"
  resources :wows, only: [:new, :create]
end
