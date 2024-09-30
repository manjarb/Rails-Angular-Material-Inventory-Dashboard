require 'rails_helper'

RSpec.describe Preference, type: :model do
  let(:valid_attributes) do
    {
      material: 'Carbon Steel',
      form: 'Coils',
      grade: 'S235JRH',
      choice: '1st Choice',
      width_min: 1200,
      width_max: 1500,
      thickness_min: 3,
      thickness_max: 15
    }
  end

  context 'validations' do
    it 'is valid with unique attributes' do
      preference = Preference.new(valid_attributes)
      expect(preference).to be_valid
    end

    it 'is not valid with duplicate combination of material, form, grade, choice, width, and thickness' do
      Preference.create!(valid_attributes)

      duplicate_preference = Preference.new(valid_attributes)
      expect(duplicate_preference).not_to be_valid
      expect(duplicate_preference.errors[:material]).to include('combination already exists')
    end

    it 'is valid if any of the scope fields are different' do
      # Same attributes except a different form
      Preference.create!(valid_attributes)

      new_attributes = valid_attributes.merge(form: 'Plates')
      preference = Preference.new(new_attributes)

      expect(preference).to be_valid
    end
  end
end
