# frozen_string_literal: true

# Includes module AuthHelper to set current player.
class ApplicationController < ActionController::Base
  include AuthHelper

  before_action :set_current_player

  add_flash_types :success, :warning, :info
end
