# frozen_string_literal: true

module Host
  class RoomsController < ApplicationController
    before_action :authenticate_user!

    def index
      @listing = current_user.listings.find(params[:listing_id])
      @rooms = @listing.rooms.all
    end

    def create
      @listing = current_user.listings.find(params[:listing_id])
      @room = @listing.rooms.new(room_create_params)

      if @room.save
        Rails.logger.info("Room created successfully")
        # redirect_to host_listing_rooms_path(@listing)
      else
        flash.now[:errors] = @room.errors.full_messages
        # render :new
      end
    end

    def destroy
      @room.destroy
      Rails.logger.info("Room deleted successfully")
    end

    private

    def room_create_params
      params.require(:room).permit(:room_type, beds_attributes: %i[id bed_type])
    end
  end
end
