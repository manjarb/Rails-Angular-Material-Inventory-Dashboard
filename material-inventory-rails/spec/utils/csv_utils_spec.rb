require 'rails_helper'
require 'csv'

RSpec.describe CsvUtils do
  describe '.normalize_inventory_headers' do
    let(:inventory_csv_data) do
      CSV.parse("Product Number,Material,Form,Choice,Grade,Finish,Surface,Quantity,Weight (t),Length (mm),Width (mm),Height (mm),Thickness (mm),Outer Diameter (mm),Wall Thickness (mm),Web Thickness (mm),Flange Thickness (mm),Certificates,Location\n"\
                "12345678,Steel,Sheet,1st Choice,S355,Galvanized,O,10,25.5,1000,500,100,5,200,10,2,1,Cert1,US",
                headers: true)
    end

    it 'normalizes inventory headers correctly' do
      row = inventory_csv_data.first
      normalized_row = CsvUtils.normalize_inventory_headers(row)

      expect(normalized_row['product_number']).to eq('12345678')
      expect(normalized_row['material']).to eq('Steel')
      expect(normalized_row['form']).to eq('Sheet')
      expect(normalized_row['choice']).to eq('1st Choice')
      expect(normalized_row['grade']).to eq('S355')
      expect(normalized_row['finish']).to eq('Galvanized')
      expect(normalized_row['surface']).to eq('O')
      expect(normalized_row['quantity']).to eq(10)
      expect(normalized_row['weight']).to eq(25.5)
      expect(normalized_row['length']).to eq(1000)
      expect(normalized_row['width']).to eq(500)
      expect(normalized_row['height']).to eq(100)
      expect(normalized_row['thickness']).to eq(5)
      expect(normalized_row['outer_diameter']).to eq(200)
      expect(normalized_row['wall_thickness']).to eq(10)
      expect(normalized_row['web_thickness']).to eq(2)
      expect(normalized_row['flange_thickness']).to eq(1)
      expect(normalized_row['certificates']).to eq('Cert1')
      expect(normalized_row['location']).to eq('US')
    end
  end

  describe '.normalize_preference_headers' do
    let(:preference_csv_data) do
      CSV.parse("Material,Form,Grade,Choice,Width (Min),Width (Max),Thickness (Min),Thickness (Max)\n"\
                "Carbon Steel,Coils,S235JRH,,1200,1500,3,15",
                headers: true)
    end

    it 'normalizes preference headers correctly' do
      row = preference_csv_data.first
      normalized_row = CsvUtils.normalize_preference_headers(row)

      expect(normalized_row['material']).to eq('Carbon Steel')
      expect(normalized_row['form']).to eq('Coils')
      expect(normalized_row['grade']).to eq('S235JRH')
      expect(normalized_row['choice']).to be_nil
      expect(normalized_row['width_min']).to eq(1200)
      expect(normalized_row['width_max']).to eq(1500)
      expect(normalized_row['thickness_min']).to eq(3)
      expect(normalized_row['thickness_max']).to eq(15)
    end
  end

  describe '.convert_to_number' do
    it 'converts numeric string to float' do
      expect(CsvUtils.send(:convert_to_number, '25.5')).to eq(25.5)
    end

    it 'converts fraction string to float' do
      expect(CsvUtils.send(:convert_to_number, '7/3')).to be_within(0.01).of(2.33)
    end
  end

  describe '.numeric_field?' do
    it 'returns true for numeric string' do
      expect(CsvUtils.send(:numeric_field?, '25.5')).to be true
    end

    it 'returns true for fraction string' do
      expect(CsvUtils.send(:numeric_field?, '7/3')).to be true
    end

    it 'returns false for non-numeric string' do
      expect(CsvUtils.send(:numeric_field?, 'abc')).to be false
    end
  end
end
