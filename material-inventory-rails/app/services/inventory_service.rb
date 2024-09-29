class InventoryService
  BATCH_SIZE = 100

  def self.upsert_inventory_items(inventory_items)
    # Perform batch upsert based on product_number
    InventoryItem.upsert_all(
      inventory_items,
      unique_by: :product_number
    )
  end

  def self.process_file(file)
    inventory_items = []

    # Wrap the operation in a transaction to ensure data integrity
    InventoryItem.transaction do
      CSV.foreach(file.path, headers: true) do |row|
        # Normalize headers and convert numeric fields
        normalized_row = CsvUtils.normalize_inventory_headers(row)
        normalized_row['form_choice'] = "#{normalized_row['form']} #{normalized_row['choice']}".strip
        inventory_items << normalized_row

        if inventory_items.size >= BATCH_SIZE
          # Upsert items in batches
          upsert_inventory_items(inventory_items)
          inventory_items.clear  # Clear the array for the next batch
        end
      end

      # Upsert remaining records if any are left after the loop
      upsert_inventory_items(inventory_items) if inventory_items.any?
    end
  end

  def self.serialize_inventory_item(item)
    {
      product_number: item.product_number,
      form: item.form,
      choice: item.choice,
      form_choice: item.form_choice,
      grade: item.grade,
      surface: item.surface,
      finish: item.finish,
      length: item.length,
      width: item.width,
      height: item.height,
      thickness: item.thickness,
      outer_diameter: item.outer_diameter,
      wall_thickness: item.wall_thickness,
      web_thickness: item.web_thickness,
      flange_thickness: item.flange_thickness,
      quantity: item.quantity,
      weight: item.weight.to_f,
      location: item.location
    }
  end
end
