class GamesController < ApplicationController

  def new
    g = Game.create!
    logger.debug "~~~~~~~~ new game created!"
    logger.debug g
    render json: g.to_jsonable
  end

  # Get the latest game or create a new one
  def index
    g = Game.last
    if g.is_guessed
      g = Game.create!
    end
    logger.debug g.inspect
    render json: g.to_jsonable
  end

  def show
    g = Game.find params[:id]
    logger.debug g.inspect
    render json: g.to_jsonable
  end

  def board
    g = Game.find params[:game_id]
    g.board = params[:board]
    g.save!
    logger.debug g.inspect
    render json: g.to_jsonable
  end

  def guess
    g = Game.find params[:game_id]
    guess = params[:guess].strip.downcase

    # Update game state
    g.last_guess = guess
    if guess == g.answer.downcase
      logger.debug "!!!!!!!! got it #{guess}"
      g.is_guessed = true
    end
    g.save!

    logger.debug g.inspect
    render json: g.to_jsonable
  end


end
