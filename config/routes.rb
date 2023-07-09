Rails.application.routes.draw do
  root "static_pages#home"

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  use_doorkeeper

  namespace :host do
    resources :listings do
      resources :photos, only: %i[index new show create]
      resources :rooms, only: %i[index create destroy]
    end
  end

  resources :listings, only: %i[index show]

  draw :api
end
