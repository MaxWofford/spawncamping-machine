class GamesController < ApplicationController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def index
    @games = Game.all
  end

  def show
    @game_price = ((((@game.reducedPrice.to_i - @game.reducedPrice.to_i * @game.sale / 100) / conversion_rate) / 100).ceil)* 100
    @price_in_doge = number_with_delimiter(((((@game.reducedPrice.to_i - @game.reducedPrice.to_i * @game.sale / 100) / conversion_rate) / 100).ceil)* 100 , :delimiter => ',')
  end

  def new
    @game = current_user.games.build
  end

  # GET /games/1/edit
  def edit
  end

  def create
    @game = current_user.games.build(game_params)

    respond_to do |format|
      if @game.save
        format.html { redirect_to @game, notice: 'Game was successfully created.' }
        format.json { render :show, status: :created, location: @game }
      else
        format.html { render :new }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @game.update(game_params)
        format.html { redirect_to @game, notice: 'Game was successfully updated.' }
        format.json { render :show, status: :ok, location: @game }
      else
        format.html { render :edit }
        format.json { render json: @game.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @game.destroy
    respond_to do |format|
      format.html { redirect_to games_url, notice: 'Game was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def set_game
      @game = Game.find(params[:id])
    end

    def game_params
      params.require(:game).permit(:title, :description, :reducedPrice, :sale, :user_id, :image, :stock)
    end
end
