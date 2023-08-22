class VenuesController < ApplicationController
  def index
    @venues = Venue.order(created_at: :desc)
  end
end
