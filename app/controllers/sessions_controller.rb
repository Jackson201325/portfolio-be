# frozen_string_literal: true

class SessionsController < ApplicationController
  def test_sign_in
    user = User.find_by(email: params[:email])
    if user.valid_password?(params[:password])
      begin
        warden.set_user(user, scope: :user)
        byebug
      rescue StandardError => e
        byebug
        puts e
      end
      # sign_in(user) # Use Devise's sign_in helper
      redirect_to root_path
    else
      render plain: "Invalid credentials"
    end
  end
end
