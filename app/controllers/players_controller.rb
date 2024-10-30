class PlayersController < ApplicationController
  def show
    @player = Player.find(params[:id])
    render json: @player
  end

  def create
    @player = Player.new(player_params.merge(game: Game.find_by(code: game_params[:game_code])))
    if @player.save
      redirect_to @player, notice: "Player was successfully created."
    else
      render json: @player.errors, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound => e
    render json: {error: e.message}, status: :unprocessable_entity
  end

  private

  def player_params
    params.require(:player).permit(:name)
  end

  def game_params
    params.require(:player).permit(:game_code)
  end
end
