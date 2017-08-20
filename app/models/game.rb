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
    self.unused_cards = Card.where(category: Category.find_by(name: category)).where.not(id: self.used_cards).pluck(:id).shuffle if self.unused_cards.empty?
    return [Card.find(self.unused_cards[0]), Card.find(self.unused_cards[1])]
  end

  # Increments the 'votes' attribute by 1 for the card that was voted on. Both cards that were voted on are added to the game's used_cards array
  def update_vote_count(card)
    card.increment!(:votes)
    self.used_cards.push(self.unused_cards.shift, self.unused_cards.shift)
  end

  def game_over?
    self.unused_cards.length <= 1
  end

end