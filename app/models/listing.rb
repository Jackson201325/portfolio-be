# frozen_string_literal: true

# == Schema Information
#
# Table name: listings
#
#  id                :bigint           not null, primary key
#  host_id           :bigint           not null
#  title             :string           not null
#  about             :text
#  max_guest         :integer          default(1)
#  address_line1     :string
#  address_line2     :string
#  city              :string
#  state             :string
#  postal_code       :string
#  country           :string
#  lat               :decimal(10, 6)
#  lng               :decimal(10, 6)
#  status            :integer          default("draft")
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  nightly_price     :integer
#  cleaning_fee      :integer
#  stripe_listing_id :string
#

class Listing < ApplicationRecord
  validates :title, presence: true
  validates :max_guest, numericality: { greater_than: 0, less_than_or_equal_to: 100 }
  validates :nightly_price, numericality: { greater_than: 0, less_than_or_equal_to: 10_000 }
  validates :cleaning_fee, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 10_000 }

  belongs_to :host, class_name: "User", foreign_key: "host_id"

  has_many :rooms, dependent: :destroy
  has_many :photos, dependent: :destroy
  has_many :reservation, dependent: :destroy

  enum status: { draft: 0, published: 1, archived: 2 }

  scope :published, -> { where(status: :published) }
  scope :draft, -> { where(status: :draft) }
  scope :archived, -> { where(status: :archived) }

  def full_address
    [address_line1, address_line2, city, state, postal_code, country].compact.join(" ")
  end
end
