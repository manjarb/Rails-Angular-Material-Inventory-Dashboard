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
end
