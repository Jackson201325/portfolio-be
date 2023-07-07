# frozen_string_literal: true

# == Schema Information
#
# Table name: beds
#
#  id         :bigint           not null, primary key
#  room_id    :bigint           not null
#  bed_type   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Bed < ApplicationRecord
  belongs_to :room

  enum bed_type: {
    twin: 0,
    twin_xl: 1,
    full: 2,
    queen: 3,
    king: 4,
    california_king: 5
  }
end
