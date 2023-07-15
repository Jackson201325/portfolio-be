# frozen_string_literal: true

class EventJob < ApplicationJob
  queue_as :default

  def perform(event)
    case event.source
    when "stripe"
      stripe_event = Strip::Event.construct_from(
        Json.parse(event.request_body, symbolize_names: true)
      )
      begin
        handle_stripe_event(stripe_event)
        stripe_event.update(event_type: event.type, status: :processed, error_message: "")
      rescue StandardError => e
        event.update(
          error_message: "Error while handling Stripe event: #{e.message}",
          status: :failed
        )
      end
    else
      event.update(error_message: "Unknown event source: #{event.source}")
    end
  end

  def handle_stripe_event(event)
    case event.type
    when "checktout.session.completed"
      chekout_session = event.data.object
      puts "Checkout session Id: #{chekout_session.id}"
      puts "Checkout session Metadata: #{chekout_session.metadataa}"
    end
  end
end
