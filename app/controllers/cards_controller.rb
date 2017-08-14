class CardsController < ApplicationController

  before_filter :authenticate, only: [:index, :new, :create, :edit, :destroy]

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
    @total_cards = Card.total_cards
    @total_votes = Card.total_votes
    @title = "Results"
    @tilter_feature = false
    @fixed_nav = true
  end

  def results_enemies
    @cards = Card.get_results("Enemy")
    @total_cards = Card.total_cards("Enemy")
    @total_votes = Card.total_votes("Enemy")
    @title = "Results (Enemies)"
    @tilter_feature = false
    @fixed_nav = true
    @background = "enemies-background.png"
  end

  def results_outfits
    @cards = Card.get_results("Outfit")
    @total_cards = Card.total_cards("Outfit")
    @total_votes = Card.total_votes("Outfit")
    @title = "Results (Outfits)"
    @tilter_feature = false
    @fixed_nav = true
    @background = "outfits-background.png"
  end

  def results_allies
    @cards = Card.get_results("Ally")
    @total_cards = Card.total_cards("Ally")
    @total_votes = Card.total_votes("Ally")
    @title = "Results (Allies)"
    @tilter_feature = false
    @fixed_nav = true
    @background = "allies-background.png"
  end

  def index
    @cards = Card.get_cards_for_index
    @fixed_nav = true
  end

  def new
    @card = Card.new
  end

  def create
    @card = Card.new(name: params[:card][:name], description: params[:card][:description], image: params[:card][:image])
    params[:category_id].empty? ? @card.category = nil : @card.category = Category.find(params[:category_id])
    if @card.save
      redirect_to cards_path
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
        params[:category_id].empty? ? @card.category = nil : @card.category = Category.find(params[:category_id])
        if @card.update(name: params[:card][:name], description:params[:card][:description], image: params[:card][:image])
          format.html { redirect_to cards_path }
        else
          format.html { render :edit }
        end
      else
        Card.update_vote_count(@card)
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
    redirect_to cards_path
  end

protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN"] && password == ENV["PASSWORD"]
    end
  end

end
