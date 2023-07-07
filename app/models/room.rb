# frozen_string_literal: true

# == Schema Information
#
# Table name: rooms
#
#  id         :bigint           not null, primary key
#  listing_id :bigint           not null
#  room_type  :integer          default("bedroom")
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Room < ApplicationRecord
  belongs_to :listing

  has_many :beds, dependent: :destroy

  accepts_nested_attributes_for :beds, allow_destroy: true

  enum room_type: {
    bedroom: 0,
    primary_bedroom: 1,
    living_room: 2,
    basement: 3
  }
end
