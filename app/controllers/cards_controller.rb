class CardsController < ApplicationController

  before_action :authenticate, only: [:index, :new, :create, :edit, :destroy]

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
        current_game.update_vote_count(@card)
        update_current_game
        @total_votes = Card.total_votes(@card.category.name)
        if !current_game.game_over?
          @cards = current_game.retrieve_cards(@card.category.name)
          update_current_game
        end
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

  def enemies
    set_current_game nil
    set_current_game Game.new
    @cards = current_game.retrieve_cards("Enemy")
    update_current_game
    @background =  browser.device.mobile? ? "enemies-background-mobile.jpg" : "enemies-background.png" 
    @position = ["left_card", "right_card"]
    @fixed_nav = false
    @tilter_feature = true
    @total_votes = Card.total_votes("Enemy")
    @title = "Vote Enemies"
  end

  def allies
    set_current_game nil
    set_current_game Game.new
    @cards = current_game.retrieve_cards("Ally")
    update_current_game
    @background =  browser.device.mobile? ? "allies-background-mobile.jpg" : "allies-background.png"   
    @position = ["left_card", "right_card"]
    @fixed_nav = false
    @tilter_feature = true
    @total_votes = Card.total_votes("Ally")
    @title = "Vote Allies"
  end

  def outfits
    set_current_game nil
    set_current_game Game.new
    @cards = current_game.retrieve_cards("Outfit")
    update_current_game
    @background =  browser.device.mobile? ? "outfits-background-mobile.jpg" : "outfits-background.png"   
    @position = ["left_card", "right_card"]
    @fixed_nav = false
    @tilter_feature = true
    @total_votes = Card.total_votes("Outfit")
    @title = "Vote Outfits"
  end

  def results
    @cards = Card.get_results.paginate(page: params[:page], per_page: 6)
    respond_to do |format|
      format.html
      format.js { render 'results.js' }
    end
    @background =  browser.device.mobile? ? "background-mobile.jpg" : "background.png"
    @fixed_nav = true
    @tilter_feature = false
    @total_cards = Card.total_cards
    @total_votes = Card.total_votes
    @title = "Results"
  end

  def results_enemies
    @cards = Card.get_results("Enemy").paginate(page: params[:page], per_page: 6)
    respond_to do |format|
      format.html
      format.js { render 'results.js' }
    end
    browser.device.mobile? ? @background = "enemies-background-mobile.jpg" : @background = "enemies-background.png"
    @fixed_nav = true
    @tilter_feature = false
    @total_cards = Card.total_cards("Enemy")
    @total_votes = Card.total_votes("Enemy")
    @title = "Results (Enemies)"
  end

  def results_allies
    @cards = Card.get_results("Ally").paginate(page: params[:page], per_page: 6)
    respond_to do |format|
      format.html
      format.js { render 'results.js' }
    end
    @background =  browser.device.mobile? ? "allies-background-mobile.jpg" : "allies-background.png"
    @fixed_nav = true
    @tilter_feature = false
    @total_cards = Card.total_cards("Ally")
    @total_votes = Card.total_votes("Ally")
    @title = "Results (Allies)"
  end

  def results_outfits
    @cards = Card.get_results("Outfit").paginate(page: params[:page], per_page: 6)
    respond_to do |format|
      format.html
      format.js { render 'results.js' }
    end
    @background =  browser.device.mobile? ? "outfits-background-mobile.jpg" : "outfits-background.png"   
    @fixed_nav = true
    @tilter_feature = false
    @total_cards = Card.total_cards("Outfit")
    @total_votes = Card.total_votes("Outfit")
    @title = "Results (Outfits)"
  end

protected

  def authenticate
    authenticate_or_request_with_http_basic do |username, password|
      username == ENV["ADMIN"] && password == ENV["PASSWORD"]
    end
  end

end
