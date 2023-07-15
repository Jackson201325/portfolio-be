require "resque/server"

Rails.application.routes.draw do
  root "static_pages#home"

  resque_web_constraint = lambda do |request|
    current_user = request.env["warden"].user
    # current_user.present? && current_user.respond_to?(:admin?) && current_user.admin?
    current_user.present?
  end

  constraints resque_web_constraint do
    mount Resque::Server, at: "/jobs"
  end

  devise_for :users, controllers: { omniauth_callbacks: "users/omniauth_callbacks" }
  use_doorkeeper

  resources :reservations, only: %i[index show new create] do
    member do
      post '/cancel', to: 'reservations#cancel'
    end
  end
  post '/webhooks/:source', to: 'webhooks#create'

  namespace :host do
    resources :listings do
      resources :photos, only: %i[index new show create]
      resources :rooms, only: %i[index create destroy]
    end
  end

  resources :listings, only: %i[index show]

  draw :api
end
