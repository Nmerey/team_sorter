# frozen_string_literal: true

# Controller class for Venues
class VenuesController < ApplicationController
  def index
    return @venues = Venue.all.order(created_at: :desc) if @current_player.sadmin?
    @venues = @current_player.venues.order(created_at: :desc)
  end
end
