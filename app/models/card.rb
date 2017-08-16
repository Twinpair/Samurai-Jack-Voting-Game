class Card < ApplicationRecord

  belongs_to :category
  validates :name, presence: true, uniqueness: true
  validates :description, presence: true
  validates :category, presence: true
  validates :image, presence: true

  # Returns the total votes that have been made on the cards (depending on category)
  def self.total_votes(category="all")
    return category == "all" ? Card.all.sum(:votes) : Card.where(category: Category.find_by(name: category)).sum(:votes)
  end

  # Returns the total card count (depending on category)
  def self.total_cards(category="all")
    return category == "all" ? Card.all.count : Card.where(category: Category.find_by(name: category)).count
  end

  # Orders the cards by the 'votes' attribute for results purposes
  def self.get_results(category="all")
    return category == "all" ? Card.order(votes: :desc, id: :asc) : Card.where(category: Category.find_by(name:category)).order(votes: :desc, id: :asc)
  end

  # Orders the cards by the 'updated_at' attribute for editing purposes
  def self.get_cards_for_index
    Card.order(updated_at: :desc)
  end

end
