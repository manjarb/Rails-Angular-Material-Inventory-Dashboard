require 'rails_helper'

RSpec.describe PreferenceService do
  describe '.upload_preferences' do
    let(:csv_file_path) { Rails.root.join('spec', 'preference.csv') }
    let(:file) { Rack::Test::UploadedFile.new(csv_file_path, 'text/csv') }

    before do
      # Create a sample CSV file in the fixtures folder for testing
      File.open(csv_file_path, 'w') do |f|
        f.write("Material,Form,Grade,Choice,Width (Min),Width (Max),Thickness (Min),Thickness (Max)\n")
        f.write("Carbon Steel,Coils,S235JRH,,1200,1500,3,15\n")
        f.write("Carbon Steel,Coils,S355MC,,1200,1500,3,15\n")
      end
    end

    after do
      File.delete(csv_file_path) if File.exist?(csv_file_path)
    end

    it 'processes a CSV file and inserts preference items' do
      expect { PreferenceService.upload_preferences(file) }.to change { Preference.count }.by(2)
    end

    it 'returns the newly inserted preference items' do
      new_preferences = PreferenceService.upload_preferences(file)

      expect(new_preferences.size).to eq(2)
      expect(new_preferences.first['material']).to eq('Carbon Steel')
      expect(new_preferences.first['form']).to eq('Coils')
    end
  end

  describe '.find_matches' do
    let!(:inventory_item1) do
      create(:inventory_item, material: 'Carbon Steel', form: 'Coils', grade: 'S355MC',
                              width: 1250, thickness: 5, weight: 12)
    end

    let!(:inventory_item2) do
      create(:inventory_item, material: 'Carbon Steel', form: 'Coils', grade: 'S355MC',
                              width: 1400, thickness: 7, weight: 20)
    end

    let(:preference) do
      {
        'material' => 'Carbon Steel',
        'form' => 'Coils',
        'grade' => 'S355MC',
        'width_min' => '1200',
        'width_max' => '1500',
        'thickness_min' => '3',
        'thickness_max' => '15'
      }
    end

    it 'finds inventory items matching preferences and weight criteria' do
      matches = PreferenceService.find_matches([preference], page: 1, per_page: 20, weight: 10)

      expect(matches.items.size).to eq(2)
      expect(matches.items).to include(inventory_item1, inventory_item2)
    end

    it 'returns paginated results' do
      matches = PreferenceService.find_matches([preference], page: 1, per_page: 1, weight: 10)

      expect(matches.items.size).to eq(1)
      expect(matches.items.first).to eq(inventory_item1)
    end

    it 'filters inventory items by weight greater than given weight' do
      matches = PreferenceService.find_matches([preference], page: 1, per_page: 20, weight: 15)

      expect(matches.items.size).to eq(1)
      expect(matches.items.first).to eq(inventory_item2)
    end
  end
end
