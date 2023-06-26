# frozen_string_literal: true

# == Schema Information
#
# Table name: listings
#
#  id            :bigint           not null, primary key
#  host_id       :bigint           not null
#  title         :string           not null
#  about         :text
#  max_guest     :integer          default(1)
#  address_line1 :string
#  address_line2 :string
#  city          :string
#  state         :string
#  postal_code   :string
#  country       :string
#  lat           :decimal(10, 6)
#  lng           :decimal(10, 6)
#  status        :integer          default("draft")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null

class Listing < ApplicationRecord
  validates :title, presence: true
  validates :max_guest, numericality: { greater_than: 0, less_than_or_equal_to: 100 }

  belongs_to :host, class_name: "User", foreign_key: "host_id"

  has_many :rooms, dependent: :destroy

  enum status: { draft: 0, published: 1, archived: 2 }
end
