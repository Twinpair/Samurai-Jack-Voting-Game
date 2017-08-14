class RemovePictureFromCards < ActiveRecord::Migration[5.0]
  def change
    remove_column :cards, :picture, :string
  end
end
