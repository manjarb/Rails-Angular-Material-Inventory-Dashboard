class AddUniqueIndexToInventoryItemsProductNumber < ActiveRecord::Migration[7.2]
  def change
    add_index :inventory_items, :product_number, unique: true
  end
end
