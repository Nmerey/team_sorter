class Game < ApplicationRecord
  belongs_to :venue
  belongs_to :player
end
