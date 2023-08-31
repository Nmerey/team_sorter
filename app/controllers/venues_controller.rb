class VenuesController < ApplicationController
  def index
    @venues = @current_player.venues.order(created_at: :desc)
  end
end
