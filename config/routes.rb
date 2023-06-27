Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  resources :listings, only: [:index, :show]

  namespace :host do
    resources :listings do
      resources :rooms, only: [:index, :create, :destroy]
    end
  end
end
