class RemoveUniqueIndexFromPreferences < ActiveRecord::Migration[7.2]
  def change
    remove_index :preferences, name: 'index_preferences_on_unique_attributes'
  end
end
