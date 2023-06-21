# frozen_string_literal: true

module Host
  class ListingsController < ApplicationController
    before_action :check_logged_in?

    def index
      @listings = current_user.listings.all
    end

    def show
      @listing = current_user.listings.find(params[:id])
    end

    def new
      @listing = current_user.listings.new
    end

    def create
      @listing = current_user.listings.new(listing_create_params)

      if @listing.save
        redirect_to host_listing_path(@listing)
      else
        flash.new[:errors] = @listing.errors.full_messages
        render :new
      end
    end

    def edit
      @listing = current_user.listings.find(params[:id])
    end

    def update
      @listing = current_user.listings.find(params[:id])
      if @listing.update(listing_update_params)
        redirect_to host_listing_path(@listing)
      else
        flash.now[:errors] = @listing.errors.full_messages
        render :new
      end
    end

    def destroy
      @listing = current_user.listings.find(params[:id])
      @listing.update(status: :archived)
      redirect_to host_listings_path
    end

    private

    def listing_create_params
      params.require(:listing).permit(:title, :about, :max_guest, :address_line1, :address_line2, :city, :state,
                                      :postal_code, :country, :lng, :lat)
    end

    def listing_update_params
      params.require(:listing).permit(
        :title,
        :about,
        :max_guest
      )
    end

    def check_logged_in?
      redirect_to new_user_session_path unless current_user.present?
    end
  end
end
