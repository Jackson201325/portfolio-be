# frozen_string_literal: true

module ApplicationHelper
  def require_logged_in
    redirect_to new_user_session_path unless current_user.present?
  end
end
