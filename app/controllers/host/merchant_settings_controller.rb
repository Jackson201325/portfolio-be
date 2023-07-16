# frozen_string_literal: true

module Host
  class MerchantSettingsController < ApplicationController
    before_action :authenticate_user!

    def index; end

    def connect
      unless current_user.stripe_account_id.present?
        current_user.update(is_host: true)

        account = Stripe::Account.create(
          type: "express",
          country: "US",
          email: current_user.email,
          capabilities: {
            card_payments: { requested: true },
            transfers: { requested: true },
            tax_reporting_us_1099_k: { requested: true }
          },
          business_type: "individual",
          individual: {
            email: current_user.email
          }
        )

        current_user.update(
          is_host: true,
          stripe_account_id: account.id,
          charges_enabled: false
        )
      end

      link = Stripe::AccountLink.create(
        account: current_user.stripe_account_id,
        refresh_url: connect_host_merchant_settings_url,
        return_url: connected_host_merchant_settings_url,
        type: "account_onboarding"
      )

      redirect_to link.url, status: :see_other, allow_other_host: true
    end

    def connected
      render json: { message: "Stripe account connected successfully" }
    end
  end
end
