# frozen_string_literal: true

# Controller class for Admin requests
class AdminController < ApplicationController
  def index
    @admin_requests = Admin.pending.includes(:player)
  end

  def update
    @admin_request = Admin.find(params[:admin_request_id])

    if params[:accepted]
      @admin_request.accepted!
      flash[:success] = 'Request accepted'
    else
      @admin_request.rejected!
      flash[:alert] = 'Request rejected'
    end

    redirect_to admin_index_path
  end
end
