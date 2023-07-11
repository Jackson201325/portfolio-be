# frozen_string_literal: true
#
class ReservationsController < ApplicationController
  def new
  end

  def index
  end

  def show
  end

  def create
    @reservation = current_user.reservations.new(reservations_params)
    if @reservation.save
      # create a Stripe checkout session
      listing = @reservation.listing
      checkout_session = Stripe::Checkout::Session.create(
        success_url: reservation_url(@reservation),
        cancel_url: listing_url(listing),
        customer: current_user.stripe_customer_id,
        mode: "payment",
        line_items: [
          {
            price_data: {
              unit_amount: listing.nightly_price,
              currency: "usd",
              product: listing.stripe_product_id
            },
            quantity: 1
          },
          {
            price_data: {
              unit_amount: listing.nightly_price,
              currency: "usd",
              product: ""
            },
            quantity: 1
          }
        ]
      )

      redirect_to(checkout_session.url)
    else
      flash[:errors] = @reservation.errors.full_messages
      redirect_to(listing_path(params([:reservation][:listing_id])))
    end
  end

  private

  def reservations_params
    params.require(:reservation).permit(:listing_id)
  end
end
