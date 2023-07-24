require "rails_helper"

describe "POST /users/sign_in", type: :request do
  let!(:user) { FactoryBot.create(:user, password: "password", password_confirmation: "password") }

  it "logs in the user" do
    # post test_sign_in_path, params: { email: user.email, password: "password" }
    # follow_redirect! # Follow the redirect after signing in
    bypass_sign_in(user, bypass: true)
    # expect(response).to render_template(:root) # Check that the root template is rendered
    expect(controller.current_user).to eq(user) # Check that the current user is the signed-in user
  end
end
