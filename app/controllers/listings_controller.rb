# frozen_string_literal: true

class ListingsController < ApplicationController
  def index
    @listings = Listing.all.order("created_at DESC")
  end

  def show
    @listing = Listing.find(params[:id])
  end
end
