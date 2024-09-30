require 'rails_helper'

RSpec.describe InventoryItem, type: :model do
  let(:inventory_item) { build(:inventory_item) }

  context 'validations' do
    it 'is valid with valid attributes' do
      expect(inventory_item).to be_valid
    end

    # Since the model doesn't enforce presence validation on product_number
    it 'is valid without a product_number' do
      inventory_item.product_number = nil
      expect(inventory_item).to be_valid
    end

    # Since the model doesn't enforce presence validation on material
    it 'is valid without a material' do
      inventory_item.material = nil
      expect(inventory_item).to be_valid
    end

    it 'is valid without optional fields' do
      inventory_item.surface = nil
      expect(inventory_item).to be_valid
    end
  end

  context 'callbacks' do
    it 'sets form_choice before save' do
      inventory_item.save
      expect(inventory_item.form_choice).to eq("#{inventory_item.form} #{inventory_item.choice}".strip)
    end
  end
end
