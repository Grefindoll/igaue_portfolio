Rails.application.routes.draw do
  devise_for :users
  post 'guest_sign_in', to: 'guest_sessions#create', as: :guest_sign_in
  root "home#index"
  resources :users, only: [:show,:edit,:update] do
    member do
      get :favorites # (GET /users/:id/favorites)
    end
  end
  resources :flower_spots do
    resources :favorites, only: [:create, :destroy]
  end
end
