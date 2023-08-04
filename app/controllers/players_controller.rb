class PlayersController < ApplicationController
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
		@player = Player.find(params[:id])
		if @player.destroy
			redirect_to players_path
		end
	end

	private

	def player_params
		params.require(:player).permit(:name, :rating, :t_id, :friend_id)
	end
end
