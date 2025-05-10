Rails.application.routes.draw do
  devise_for :users
  post 'guest_sign_in', to: 'guest_sessions#create'
  root "home#index"
  resources :flower_spots
end
