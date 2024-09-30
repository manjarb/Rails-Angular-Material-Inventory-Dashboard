require 'rails_helper'

RSpec.describe InventoryService do
  describe '.process_file' do
    let(:csv_file_path) { Rails.root.join('spec', 'inventory.csv') }
    let(:file) { Rack::Test::UploadedFile.new(csv_file_path, 'text/csv') }

    before do
      # Create a sample CSV file in the fixtures folder for testing
      File.open(csv_file_path, 'w') do |f|
        f.write("Product Number,Material,Form,Choice,Grade,Finish,Surface,Quantity,Weight (t),Length (mm),Width (mm),Height (mm),Thickness (mm),Outer Diameter (mm),Wall Thickness (mm),Web Thickness (mm),Flange Thickness (mm),Certificates,Location\n")
        f.write("12345678,Steel,Sheet,1st Choice,S355,Galvanized,O,10,25.5,1000,500,200,10,300,,5,2,Cert123,US\n")
        f.write("87654321,Aluminum,Plate,2nd Choice,A1050,Anodized,,5,10.0,1200,600,250,,,400,2,3,,DE\n")
      end
    end

    after do
      File.delete(csv_file_path) if File.exist?(csv_file_path)
    end

    it 'processes a CSV file and upserts inventory items' do
      expect { InventoryService.process_file(file) }.to change { InventoryItem.count }.by(2)
    end

    it 'creates inventory items with correct attributes' do
      InventoryService.process_file(file)
      inventory_item = InventoryItem.find_by(product_number: '12345678')

      expect(inventory_item).not_to be_nil
      expect(inventory_item.material).to eq('Steel')
      expect(inventory_item.form).to eq('Sheet')
      expect(inventory_item.choice).to eq('1st Choice')
      expect(inventory_item.form_choice).to eq('Sheet 1st Choice')
      expect(inventory_item.grade).to eq('S355')
      expect(inventory_item.finish).to eq('Galvanized')
      expect(inventory_item.surface).to eq('O')
      expect(inventory_item.quantity).to eq(10)
      expect(inventory_item.weight.to_f).to eq(25.5)
      expect(inventory_item.length).to eq(1000)
      expect(inventory_item.width).to eq(500)
      expect(inventory_item.height).to eq(200)
      expect(inventory_item.thickness).to eq(10)
      expect(inventory_item.outer_diameter).to eq(300)
      expect(inventory_item.wall_thickness).to be_nil
      expect(inventory_item.web_thickness).to eq(5)
      expect(inventory_item.flange_thickness).to eq(2)
      expect(inventory_item.certificates).to eq('Cert123')
      expect(inventory_item.location).to eq('US')
    end
  end

  describe '.serialize_inventory_item' do
    let(:inventory_item) { create(:inventory_item, product_number: '99999999', material: 'Copper') }

    it 'serializes an inventory item into a hash' do
      serialized_item = InventoryService.serialize_inventory_item(inventory_item)

      expect(serialized_item[:product_number]).to eq('99999999')
      expect(serialized_item[:material]).to eq('Copper')
      expect(serialized_item.keys).to include(:form, :choice, :form_choice, :grade, :finish, :length, :width, :height, :thickness, :outer_diameter, :quantity, :weight, :location)
    end
  end
end
