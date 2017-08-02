class CardsController < ApplicationController

  before_filter :authenticate, only: [:new, :create, :edit, :update, :destroy]

  def enemies
    @cards = Card.retrieve_cards("Enemy")
    @total_votes = Card.total_votes("Enemy")
    @title = "Vote Enemies"
    @tilter_feature = true
    @fixed_nav = false
    @background = "enemies-background.png"
  end

  def outfits
    @cards = Card.retrieve_cards("Outfit")
    @total_votes = Card.total_votes("Outfit")
    @title = "Vote Outfits"
    @tilter_feature = true
    @fixed_nav = false
    @background = "outfits-background.png"
  end

  def allies
    @cards = Card.retrieve_cards("Ally")
    @total_votes = Card.total_votes("Ally")
    @title = "Vote Allies"
    @tilter_feature = true
    @fixed_nav = false
    @background = "allies-background.png"
  end

  def results
    @cards = Card.get_results
    @title = "Results (All)"
    @tilter_feature = false
    @fixed_nav = true
  end

  def results_enemies
    @cards = Card.get_results("Enemy")
    @title = "Results (Enemies)"
    @tilter_feature = false
    @fixed_nav = true
    @background = "enemies-background.png"
  end

  def results_outfits
    @cards = Card.get_results("Outfit")
    @title = "Results (Outfits)"
    @tilter_feature = false
    @fixed_nav = true
    @background = "outfits-background.png"
  end

  def results_allies
    @cards = Card.get_results("Ally")
    @title = "Results (Allies)"
    @tilter_feature = false
    @fixed_nav = true
    @background = "allies-background.png"
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(name: params[:card][:name], description: params[:card][:description], category: Category.find(params[:category_id]), picture: params[:card][:picture])
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
        @card.update(name: params[:card][:name], description:params[:card][:description], category: Category.find(params[:category_id]), picture: params[:card][:picture])
        format.html { redirect_to root_path }
      else
        @card.update_vote_count
        @card.save
        @cards = Card.retrieve_cards(@card.category.name)
        @total_votes = Card.total_votes(@card.category.name)
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

protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN"] && password == ENV["PASSWORD"]
    end
  end

end
