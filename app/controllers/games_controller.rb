# frozen_string_literal: true

class GamesController < ApplicationController
  before_action :set_game, only: [:show]

  def show
    render json: @game
  end

  def create
    @game = Game.new

    if @game.save
      redirect_to @game, notice: "Game was successfully created."
    else
      render :new
    end
  end

  private

  def set_game
    @game = Game.find(params[:id])
  end
end
