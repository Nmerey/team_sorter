# frozen_string_literal: true

# Game model class
class Game < ApplicationRecord
  belongs_to :venue
  belongs_to :player
  validates_uniqueness_of :player, scope: :venue_id
end
