# frozen_string_literal: true

# Class for checking Authentication of the player using Telegram App hash token.
class AuthController < ApplicationController
  skip_before_action :set_current_player

  def show
    find_or_create_player
    
    if @current_player&.admin?
      redirect_to venues_path
    else
      flash[:notice] = "#{@current_player.fullname} is not Admin! /become_admin in bot chat!"
      render :show
    end
  end

  private

  def find_or_create_player
    return unless check_auth?(telegram_params)

    @current_player = Player.find_or_create_by(t_id: params[:id]) do |player|
      player.assign_attributes(player_params)
    end
    session[:telegram_id] = @current_player.t_id
  end

  def telegram_params
    params.permit(:id, :first_name, :last_name, :username, :photo_url, :hash, :auth_date).to_hash
  end

  def player_params
    {
      t_id: params[:id],
      name: params[:first_name],
      surname: params[:last_name],
      nickname: params[:username]
    }
  end
end
