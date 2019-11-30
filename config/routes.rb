Rails.application.routes.draw do
  devise_for :users
  root "wows#index"
  resources :wows do
   resources :ratings, only: :create
  end
  resources :users, only: :show
end
