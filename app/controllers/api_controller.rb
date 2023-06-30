# frozen_string_literal: true

class ApiController < ActionController::Base
  before_action :doorkeeper_authorize!
  skip_before_action :verify_authenticity_token

  respond_to :json

  def api_current_user
    @api_current_user ||= User.find_by(id: doorkeeper_token[:resource_owner_id])
  end
end
