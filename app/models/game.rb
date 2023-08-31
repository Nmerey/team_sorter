# frozen_string_literal: true

class Game < ApplicationRecord
  belongs_to :venue
  belongs_to :player
  validates_uniqueness_of :player, scope: :venue_id
end
