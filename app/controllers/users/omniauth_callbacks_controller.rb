# frozen_string_literal: true

module Users
  class OmniauthCallbacksController < ApplicationController
    # See https://github.com/omniauth/omniauth/wiki/FAQ#rails-session-is-clobbered-after-callback-on-developer-strategy
    skip_before_action :verify_authenticity_token, only: :google_oauth2

    def google_oauth2
      @user = create_from_omniauth

      if @user.persisted?
        successful_authentication
      else
        unsuccessful_authentication
      end
    end

    def failure
      redirect_to root_path
    end

    private

    def create_from_omniauth
      User.from_omniauth(request.env["omniauth.auth"])
    end

    def successful_authentication
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", kind: "Google"
      sign_in_and_redirect @user, event: :authentication
    end

    def unsuccessful_authentication
      session["devise.google_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
    end
  end
end
