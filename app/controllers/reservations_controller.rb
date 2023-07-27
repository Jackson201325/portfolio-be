# frozen_string_literal: true

class ReservationsController < ApplicationController
  before_action :authenticate_user!
  before_action :current_reservation, only: %i[cancel show]

  def new; end

  def index; end

  def cancel
    refund = Stripe::Refund.create({ payment_intent: @reservation.stripe_payment_intent_id })

    @reservation.update(stripe_refund_id: refund.id, status: :refunding)

    redirect_to reservation_path(@reservation)
  end

  def show; end

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
              product: listing.stripe_listing_id
            },
            quantity: 1
          },
          {
            price_data: {
              unit_amount: listing.cleaning_fee,
              currency: "usd",
              product: "prod_OFHFlxgEdRQv6h"
            },
            quantity: 1
          }
        ],
        metadata: {
          reservation_id: @reservation.id
        },
        payment_intent_data: {
          application_fee_amount: ((listing.nightly_price * 0.1) + (listing.cleaning_fee * 0.1)).to_i,
          transfer_data: {
            destination: listing.host.stripe_account_id
          },
          metadata: {
            reservation_id: @reservation.id
          }
        }
      )

      @reservation.update(session_id: checkout_session.id)
      redirect_to checkout_session.url, allow_other_host: true
    else
      flash[:errors] = @reservation.errors.full_messages
      redirect_to(listing_path(params([:reservation][:listing_id])))
    end
  end

  private

  def reservations_params
    params.require(:reservation).permit(:listing_id)
  end

  def current_reservation
    @reservation = current_user.reservations.find(params[:id])
  end
end
