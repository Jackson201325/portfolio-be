# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  unconfirmed_email      :string
#  failed_attempts        :integer          default(0), not null
#  unlock_token           :string
#  locked_at              :datetime
#  provider               :string
#  uid                    :string
#  name                   :string
#  role                   :integer          default("guest")
#  stripe_customer_id     :string
#

class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable, :lockable, :timeoutable, :trackable

  devise :omniauthable, omniauth_providers: [:google_oauth2]

  after_commit :maybe_create_stripe_customer, on: %i[create update]

  has_many :listings, dependent: :destroy, foreign_key: "host_id"
  has_many :reservations, dependent: :destroy, foreign_key: "guest_id"

  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  enum role: { guest: 0, host: 1 }

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid) do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.name = auth.info.name # assuming the user model has a name

      # user.image = auth.info.image # assuming the user model has an image
      # If you are using confirmable and the provider(s) you use validate emails,
      # uncomment the line below to skip the confirmation emails.
      # user.skip_confirmation!
    end
  end

  def self.authenticate(email, password)
    user = User.find_for_authentication(email: email)
    user&.valid_password?(password) ? user : nil
  end

  # def update_doorkeeper_credentials(auth)
  #   update(
  #     doorkeeper_access_token: auth.credentials.token,
  #     doorkeeper_refresh_token: auth.credentials.refresh_token,
  #     doorkeeper_expires_at: Time.at(auth.credentials.expires_at)
  #   )
  # end
  #
  # def self.doorkeeper_oauth_client
  #   @doorkeeper_oauth_client ||= OAuth2::Client.new(
  #     ENV.fetch("DOORKEEPER_APP_ID"),
  #     ENV.fetch("DOORKEEPER_APP_SECRET"),
  #     site: ENV.fetch("DOORKEEPER_APP_URL")
  #   )
  # end
  #
  # def doorkeeper_access_token_raw
  #   OAuth2::AccessToken.new(
  #     User.doorkeeper_oauth_client,
  #     doorkeeper_access_token,
  #     expires_at: doorkeeper_expires_at,
  #     refresh_token: doorkeeper_refresh_token
  #   )
  # end
  #
  # def doorkeeper
  #   @doorkeeper ||= doorkeeper_access_token_raw
  #   if @doorkeeper.expired?
  #     @doorkeeper = @doorkeeper.refresh!
  #     update doorkeeper_refresh_token: @doorkeeper.refresh_token,
  #            doorkeeper_expires_at: @doorkeeper.expires_at,
  #            doorkeeper_access_token: @doorkeeper.token
  #   end
  #   @doorkeeper
  # end
  #
  def maybe_create_stripe_customer
    return if stripe_customer_id.present?

    customer = Stripe::Customer.create(
      email: email,
      name: name,
      metadata: { clearbnb_id: id }
    )
    update stripe_customer_id: customer.id
  end
end
