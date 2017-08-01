class AddCategoryRefToCards < ActiveRecord::Migration[5.0]
  def change
    add_reference :cards, :category, foreign_key: true
  end
end
