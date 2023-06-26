Rails.application.routes.draw do
  root "static_pages#home"
  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }

  namespace :host do
    resources :listings do
      resources :room, only: [:index, :create, :destroy]
    end
  end
end
