class PlayersController < ApplicationController
	before_action :set_player, only:[:edit, :show, :update]
	def index
		@players = Player.not_friends
	end

	def show
		
	end

	def create
		
	end

	def edit

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
			redirect_to players_path
		end
	end

	private

	def set_player
		@player = Player.find(params[:id])
	end

	def player_params
		params.require(:player).permit(:name, :rating, :t_id, :friend_id)
	end
end
