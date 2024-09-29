class AddFormChoiceToInventoryItems < ActiveRecord::Migration[7.2]
  def change
    add_column :inventory_items, :form_choice, :string
  end
end
