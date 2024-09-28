class AddUniqueIndexToPreferences < ActiveRecord::Migration[7.2]
  def change
    add_index :preferences, [:material, :form, :grade, :choice, :width_min, :width_max, :thickness_min, :thickness_max], unique: true, name: 'index_preferences_on_unique_attributes'
  end
end
