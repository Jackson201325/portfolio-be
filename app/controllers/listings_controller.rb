# frozen_string_literal: true

class ListingsController < ApplicationController
  def index
    @published = Listing.published
    @drafted = Listing.drafted
    @archived = Listing.archived
  end

  def show
    @listing = Listing.find(params[:id])
  end
end
