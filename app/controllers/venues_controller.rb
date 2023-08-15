class VenuesController < ApplicationController
  def index
    @venues = Venue.order(:created_at)
  end
end
