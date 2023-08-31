class PlayersController < ApplicationController
	before_action :set_player, only:[:edit, :show, :update]

	def index
		if params[:venue_id]
			venue = Venue.find(params[:venue_id])
			players = venue.players.not_friends
		else
			players = Player.played_together_with(@current_player).not_friends
		end

		@players = players.order('created_at').paginate(page: params[:page], per_page: 12)
	end

	def destroy
		if @player.destroy
			redirect_to players_path
			flash[:alert] = "Player has been deleted"
		end
	end

	def update
		if @player.update(player_params)
			flash[:success] = "Player has been updated"
			redirect_to players_path(venue_id: params[:venue_id])
		end
	end

	private

	def set_player
		@player = Player.find(params[:id])
	end

	def player_params
		params.require(:player).permit(:name, :surname, :nickname, :rating, :t_id, :friend_id)
	end
end
