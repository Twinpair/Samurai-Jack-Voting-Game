class Game

  include ActiveModel::AttributeMethods, ActiveModel::Serializers::JSON

  attr_accessor :used_cards
  attr_accessor :unused_cards

  def initialize
    @used_cards = []
    @unused_cards = []
  end

  def attributes
    {'used_cards' => nil,
     'unused_cards' => nil}
  end

  def attributes=(hash)
    hash.each do |key, value|
      send("#{key}=", value)
    end
  end

  # Returns the two cards that will be voted on (depending on category)
  def retrieve_cards(category)
    cards_to_return = []
    self.unused_cards = Card.where(category: Category.find_by(name: category)).where.not(id: self.used_cards).pluck(:id).shuffle if self.unused_cards.empty?
    cards_to_return.push(Card.find(self.unused_cards[0]), Card.find(self.unused_cards[1]))
    return cards_to_return
  end

  # Increments the 'votes' attribute by 1 for the item that was voted on. Adds the cards that were voted on to the used_cards array
  def update_vote_count(card)
    card.votes += 1
    card.save
    self.used_cards.push(self.unused_cards.shift, self.unused_cards.shift)
    reset_used_cards if self.unused_cards.length <= 1
  end

  # Clears the used_cards array, so the game can use all cards again
  def reset_used_cards
    self.used_cards = []
  end

end