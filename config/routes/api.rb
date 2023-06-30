# frozen_string_literal: true

namespace :api do
  namespace :v1 do
    namespace :host do
      resources :listings
    end

    scope :users, module: :users do
      post "/", to: "registrations#create", as: :user_registration
    end
  end
end

scope :api do
  scope :v1 do
    use_doorkeeper do
      skip_controllers :authorization, :applications, :authorize_applications
    end
  end
end
