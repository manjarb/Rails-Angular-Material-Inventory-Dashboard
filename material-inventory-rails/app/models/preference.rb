class Preference < ApplicationRecord
  validates :material, uniqueness: {
    scope: [:form, :grade, :choice, :width_min, :width_max, :thickness_min, :thickness_max],
    message: "combination already exists"
  }
end
