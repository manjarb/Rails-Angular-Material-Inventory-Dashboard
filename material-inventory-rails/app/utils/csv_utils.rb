module CsvUtils
  # Maps CSV headers to model attributes
  INVENTORY_HEADER_MAPPING = {
    "Product Number" => "product_number",
    "Material" => "material",
    "Form" => "form",
    "Choice" => "choice",
    "Grade" => "grade",
    "Finish" => "finish",
    "Surface" => "surface",
    "Quantity" => "quantity",
    "Weight (t)" => "weight",
    "Length (mm)" => "length",
    "Width (mm)" => "width",
    "Height (mm)" => "height",
    "Thickness (mm)" => "thickness",
    "Outer Diameter (mm)" => "outer_diameter",
    "Wall Thickness (mm)" => "wall_thickness",
    "Web Thickness (mm)" => "web_thickness",
    "Flange Thickness (mm)" => "flange_thickness",
    "Certificates" => "certificates",
    "Location" => "location"
  }

  PREFERENCE_HEADER_MAPPING = {
    "Material" => "material",
    "Form" => "form",
    "Grade" => "grade",
    "Choice" => "choice",
    "Width (Min)" => "width_min",
    "Width (Max)" => "width_max",
    "Thickness (Min)" => "thickness_min",
    "Thickness (Max)" => "thickness_max"
  }

  # General method to normalize headers and values
  def self.normalize_headers(row, header_mapping)
    row.to_hash.transform_keys do |key|
      header_mapping[key.strip] || key.strip
    end.transform_values.with_index do |value, index|
      value = value.strip if value.is_a?(String)

      # Bypass numeric conversion for product_number
      header_key = row.headers[index].strip
      if header_key == 'Product Number' || header_mapping[header_key] == 'product_number'
        value
      else
        numeric_field?(value) ? convert_to_number(value) : value
      end
    end
  end

  # Wrapper method to normalize inventory headers
  def self.normalize_inventory_headers(row)
    normalize_headers(row, INVENTORY_HEADER_MAPPING)
  end

  # Wrapper method to normalize preference headers
  def self.normalize_preference_headers(row)
    normalize_headers(row, PREFERENCE_HEADER_MAPPING)
  end

  private

  # Check if a value is numeric or an expression like "7/3"
  def self.numeric_field?(value)
    value.to_s.match?(/\A[-+]?\d*\.?\d+(\/\d+)?\Z/)
  end

  # Convert value to float, handle expressions like "7/3"
  def self.convert_to_number(value)
    if value.include?('/')
      numerator, denominator = value.split('/').map(&:to_f)
      numerator / denominator
    else
      value.to_f
    end
  end
end
