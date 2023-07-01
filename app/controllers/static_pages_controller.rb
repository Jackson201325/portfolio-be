# frozen_string_literal: true

class StaticPagesController < ApplicationController
  def home
    @application = Doorkeeper::Application.find_by(name: "Web client")

    @application = {
      name: @application.name,
      client_id: @application.uid,
      client_secret: @application.secret
    }
  end
end
