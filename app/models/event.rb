# frozen_string_literal: true

# == Schema Information
#
# Table name: events
#
#  id             :bigint           not null, primary key
#  request_body   :text
#  status         :integer          default("pending")
#  error_messages :text
#  source         :string
#  event_type     :string
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
class Event < ApplicationRecord
  enum status: { pending: 0, success: 1, failed: 2 }
end
