class Card < ApplicationRecord

  belongs_to :category
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :category, presence: true
  validates :image, presence: true

  # Variables to keep track of what cards were used and unused
  @used_cards = []
  @unused_cards = []
  @save_category = nil

  # Returns the two cards that will be voted on (depending on category)
  def self.retrieve_cards(category)
    cards_to_return = []
    self.reset_used_cards if category != @save_category
    @save_category = category
    @unused_cards = Card.where(category: Category.find_by(name: category)).where.not(id: @used_cards).shuffle
    cards_to_return.push(@unused_cards.first, @unused_cards.second)
    return cards_to_return
  end

  # Returns the total votes that have been made on the cards (depending on category)
  def self.total_votes(category="all")
    return category == "all" ? Card.all.sum(:votes) : Card.where(category: Category.find_by(name: category)).sum(:votes)
  end

  # Returns the total card count (depending on category)
  def self.total_cards(category="all")
    return category == "all" ? Card.all.count : Card.where(category: Category.find_by(name: category)).count
  end

  # Clears the used_cards array, so the game can use all cards again
  def self.reset_used_cards
    @used_cards = []
  end

  # Increments the 'votes' attribute by 1 for the item that was voted on. Adds the cards that were voted on to the used_cards array
  def self.update_vote_count(card)
    card.votes += 1
    card.save
    @used_cards.push(@unused_cards.shift, @unused_cards.shift)
    self.reset_used_cards if @unused_cards.length <= 1
  end

  # Orders the cards by the 'votes' attribute for results purposes
  def self.get_results(category="all")
    return category == "all" ? Card.order(votes: :desc) : Card.where(category: Category.find_by(name:category)).order(votes: :desc)
  end

  # Orders the cards by the 'updated_at' attribute for editing purposes
  def self.get_cards_for_index
    Card.order(updated_at: :asc)
  end

end
