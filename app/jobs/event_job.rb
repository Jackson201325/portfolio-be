# frozen_string_literal: true

class EventJob < ApplicationJob
  queue_as :default

  def perform(event)
    case event.source
    when "stripe"
      stripe_event = Stripe::Event.construct_from(
        JSON.parse(event.request_body, symbolize_names: true)
      )
      begin
        handle_stripe_event(stripe_event)
        event.update(event_type: stripe_event.type, status: :success, error_messages: "")
      rescue StandardError => e
        event.update(
          error_messages: "Error while handling Stripe event: #{e.message}",
          status: :failed
        )
      end
    else
      event.update(error_messages: "Unknown event source: #{event.source}")
    end
  end

  def handle_stripe_event(event)
    case event.type
    when "checkout.session.completed"
      checkout_session = event.data.object
      reservation = Reservation.find_by(session_id: checkout_session.id)

      raise "Reservation not found for checkout session: #{checkout_session.id}" if reservation.nil?

      reservation.update(status: :confirmed, stripe_payment_intent_id: checkout_session.payment_intent)
    when "charge.refunded"
      charge = event.data.object
      reservation = Reservation.find_by(stripe_payment_intent_id: charge.payment_intent)

      raise "Reservation not found for checkout session: #{charge.payment_intent}" if reservation.nil?

      reservation.update(status: :cancelled)
    end
  end
end
