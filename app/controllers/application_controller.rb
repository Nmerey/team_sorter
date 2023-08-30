class ApplicationController < ActionController::Base
	include AuthHelper

	before_action :set_current_player

	add_flash_types :success, :warning, :info
end
