# frozen_string_literal: true

module Host
  class PhotosController < ApplicationController
    before_action :authenticate_user!
    before_action :set_listing

    def index
      @photos = @listing.photos
    end

    def new
      @photo = @listing.photos.new
    end

    def show
      @photo = @listing.photos.find(params[:listing_id])
    end

    def create
      @photo = @listing.photos.new(photo_params)
      if @photo.save
        redirect_to(host_listing_photos_path(@listing), notice: "Photo was successfully created.")
      else
        render(:new)
      end
    end

    private

    def set_listing
      @listing = current_user.listings.find(params[:listing_id])
    end

    def photo_params
      params.require(:photos).permit(:image, :caption)
    end
  end
end
