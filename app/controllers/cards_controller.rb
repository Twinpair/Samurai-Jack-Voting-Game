class CardsController < ApplicationController
  
  def index
    if Card.all.count <= 1
      @not_enough_cards = true
    else
      @cards = Card.retrieve_cards
    end
  end

  def leaderboards
    @cards = Card.get_leaderboard
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(name: params[:card][:name], description:params[:card][:description])
    if @card.save
      redirect_to root_path
    else
      render :new
    end
  end

  def edit
    @card = Card.find(params[:id])
  end

  def update
    @card = Card.find(params[:id])
    respond_to do |format|
      if !params[:card].nil?
        @card.update(name: params[:card][:name], description:params[:card][:description])
        format.html { redirect_to root_path }
        format.js
      else
        @card.update_vote_count
        format.html { redirect_to root_path }
        format.js
      end
    end
  end

  def destroy
    @card = Card.find(params[:id])
    @card.destroy
    redirect_to root_path
  end

end
