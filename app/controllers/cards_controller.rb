class CardsController < ApplicationController
  
  def index
    @cards = Card.retrieve_cards
    @total_votes = Card.total_votes
    @tilter_feature = true
    @fixed_nav = false
  end

  def results
    @cards = Card.get_results
    @tilter_feature = false
    @fixed_nav = true
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(name: params[:card][:name], description: params[:card][:description], picture: params[:card][:picture])
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
        @card.update(name: params[:card][:name], description:params[:card][:description], picture: params[:card][:picture])
        format.html { redirect_to root_path }
      else
        @card.update_vote_count
        @card.save
        @cards = Card.retrieve_cards
        @total_votes = Card.total_votes
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
