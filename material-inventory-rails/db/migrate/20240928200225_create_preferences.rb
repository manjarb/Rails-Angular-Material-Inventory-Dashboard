class CreatePreferences < ActiveRecord::Migration[7.2]
  def change
    create_table :preferences do |t|
      t.string :material
      t.string :form
      t.string :grade
      t.string :choice
      t.decimal :width_min
      t.decimal :width_max
      t.decimal :thickness_min
      t.decimal :thickness_max

      t.timestamps
    end
  end
end
