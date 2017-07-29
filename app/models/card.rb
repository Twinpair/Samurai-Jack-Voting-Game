class Card < ApplicationRecord

  mount_uploader :picture, PictureUploader

  # Will keep track of what cards were already voted on
  @used_cards = []

  # Returns the two cards that will be voted on
  def self.retrieve_cards
    cards_to_return = []
    unused_cards = Card.where.not(id: @used_cards).shuffle
    cards_to_return.push(unused_cards.first, unused_cards.second)
    @used_cards.push(unused_cards.shift, unused_cards.shift)
    self.reset_used_cards if unused_cards.length <= 1
    return cards_to_return
  end

  # Adds and returns all votes that have been made on the site
  def self.total_votes
    return Card.sum(:votes)
  end

  # Clears the used_cards array, so the game can use all cards again
  def self.reset_used_cards
    @used_cards = []
  end

  # Increments the 'votes' attribute by 1 for the item that was voted on
  def update_vote_count
    self.votes += 1
  end

  # Orders the items by the 'votes' attribute for result purposes
  def self.get_results
    return Card.order(votes: :desc)
  end

end
