require 'json'

class PreferenceService
  def self.find_matches
    matches = []

    # Cotinue hereee
    Preference.find_each do |preference|
      inventory_matches = InventoryItem.where(
        material: preference.material,
        form: preference.form,
        grade: preference.grade,
        choice: preference.choice
      ).where(
        width: preference.width_min..preference.width_max,
        thickness: preference.thickness_min..preference.thickness_max
      )

      inventory_matches.each do |item|
        matches << {
          preference_id: preference.id,
          inventory_id: item.id,
          inventory: item.attributes
        }
      end
    end

    matches
  end
end
