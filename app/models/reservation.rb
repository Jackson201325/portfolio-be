# frozen_string_literal: true

# == Schema Information
#
# Table name: reservations
#
#  id                       :bigint           not null, primary key
#  listing_id               :bigint           not null
#  guest_id                 :bigint           not null
#  session_id               :string
#  status                   :integer          default("pending")
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  stripe_payment_intent_id :string
#  stripe_refund_id         :string
#
class Reservation < ApplicationRecord
  belongs_to :listing
  belongs_to :guest, class_name: "User", foreign_key: "guest_id"

  enum status: { pending: 0, confirmed: 1, cancelled: 2, refunding: 3 }
end
