class CreateInventoryItems < ActiveRecord::Migration[7.2]
  def change
    create_table :inventory_items do |t|
      t.string :product_number
      t.string :material
      t.string :form
      t.string :choice
      t.string :grade
      t.string :finish
      t.string :surface
      t.integer :quantity
      t.decimal :weight
      t.decimal :length
      t.decimal :width
      t.decimal :height
      t.decimal :thickness
      t.decimal :outer_diameter
      t.decimal :wall_thickness
      t.decimal :web_thickness
      t.decimal :flange_thickness
      t.string :certificates
      t.string :location

      t.timestamps
    end
  end
end
