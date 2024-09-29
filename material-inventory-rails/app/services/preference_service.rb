require 'json'

class PreferenceService
  BATCH_SIZE = 100

  def self.upload_preferences(file)
    preference_items = []
    new_preferences = []

    Preference.transaction do
      CSV.foreach(file.path, headers: true) do |row|
        # Normalize headers using the utility
        normalized_row = CsvUtils.normalize_preference_headers(row)
        preference_items << normalized_row
        new_preferences << normalized_row

        if preference_items.size >= BATCH_SIZE
          Preference.insert_all(preference_items)
          preference_items.clear  # Clear the array for the next batch
        end
      end

      # Insert remaining records if any are left after the loop
      Preference.insert_all(preference_items) if preference_items.any?
    end

    new_preferences
  end

  def self.find_matches(preferences, page: 1, per_page: 20)
    matches = []

    preferences.each do |preference|
      # Build exact match conditions for fields that are not nil
      query_conditions = {}
      query_conditions[:material] = preference['material'] if preference['material'].present?
      query_conditions[:form] = preference['form'] if preference['form'].present?
      query_conditions[:grade] = preference['grade'] if preference['grade'].present?
      query_conditions[:choice] = preference['choice'] if preference['choice'].present?

      # Build range conditions
      range_conditions = []
      range_values = []

      if preference['width_min'].present?
        range_conditions << 'width >= ?'
        range_values << preference['width_min']
      end
      if preference['width_max'].present?
        range_conditions << 'width <= ?'
        range_values << preference['width_max']
      end
      if preference['thickness_min'].present?
        range_conditions << 'thickness >= ?'
        range_values << preference['thickness_min']
      end
      if preference['thickness_max'].present?
        range_conditions << 'thickness <= ?'
        range_values << preference['thickness_max']
      end

      # Combine the exact match conditions and the range conditions
      inventory_query = InventoryItem.where(query_conditions)

      # Only apply range conditions if there are any
      if range_conditions.any?
        full_conditions = [range_conditions.join(' AND '), *range_values]
        inventory_query = inventory_query.where(full_conditions)
      end

      # Aggregate all matching inventory items
      matches.concat(inventory_query.to_a)
    end

    # Convert all_matches to a unique set to avoid duplicates
    matches.uniq!

    # Use PaginationUtils to paginate results
    PaginationUtils.paginate_array(matches, page, per_page)
  end
end
