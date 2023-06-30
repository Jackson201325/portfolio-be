# frozen_string_literal: true

module Api
  module V1
    module Users
      class RegistrationsController < ApiController
        skip_before_action :doorkeeper_authorize!, only: %i[create]

        include DoorkeeperRegisterable

        def create
          client_app = Doorkeeper::Application.find_by(uid: user_params[:client_id])

          unless client_app
            return render json: { error: I18n.t("doorkeeper.errors.messages.invalid_client") },
                          status: :unauthorized
          end

          allowed_params = user_params.except(:client_id)
          user = User.new(allowed_params)

          if user.save
            render json: render_user(user, client_app), status: :ok
          else
            render json: { message: user.errors }, status: :unprocessable_entity
          end
        end

        def user_params
          params.permit(:email, :password, :client_id)
        end
      end
    end
  end
end

# {
#   id: 5,
#   email: "j1@test.com",
#   role: 0,
#   access_token: "JDY5IYgeQxUn5k9x4UX9rl1eIJRYOo7Wizit-EBNbjw",
#   token_type: "Bearer",
#   expires_in: 7200,
#   refresh_token: "414c221dc537ad36b4f734d35785347fa1d2362c1f5394a5feaa62a8a79b7836",
#   created_at: 1_688_126_371
# }
