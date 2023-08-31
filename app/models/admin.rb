# frozen_string_literal: true

class Admin < ApplicationRecord
  has_many :groups
  belongs_to :player

  validates_uniqueness_of :player_id

  delegate :t_id, to: :player
  enum :status, { pending: 0, accepted: 1, rejected: 2 }
end
