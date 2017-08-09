class Card < ApplicationRecord

  belongs_to :category
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :category, presence: true
  validates :picture, presence: true

  mount_uploader :picture, PictureUploader

  # Will keep track of what cards were already voted on
  @used_cards = []

  # Returns the two cards that will be voted on (depending on category)
  def self.retrieve_cards(category)
    cards_to_return = []
    unused_cards = Card.where(category: Category.find_by(name: category)).where.not(id: @used_cards).shuffle
    cards_to_return.push(unused_cards.first, unused_cards.second)
    @used_cards.push(unused_cards.shift, unused_cards.shift)
    self.reset_used_cards if unused_cards.length <= 1
    return cards_to_return
  end

  # Adds and returns all votes that have been made on the site (depending on category)
  def self.total_votes(category)
    return Card.where(category: Category.find_by(name: category)).sum(:votes)
  end

  # Clears the used_cards array, so the game can use all cards again
  def self.reset_used_cards
    @used_cards = []
  end

  # Increments the 'votes' attribute by 1 for the item that was voted on
  def update_vote_count
    self.votes += 1
  end

  # Orders the cards by the 'votes' attribute for results purposes
  def self.get_results(category="all")
    return category == "all" ? Card.order(votes: :desc) : Card.where(category: Category.find_by(name:category)).order(votes: :desc)
  end

  # Orders the cards by the 'updated_at' attribute for editing purposes
  def self.get_cards_for_index
    Card.order(updated_at: :desc)
  end

end
