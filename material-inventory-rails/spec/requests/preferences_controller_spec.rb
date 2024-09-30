require 'rails_helper'

RSpec.describe Api::V1::InventoriesController, type: :request do
  let(:csv_file_path) { Rails.root.join('spec', 'inventory.csv') }
  let(:file) { Rack::Test::UploadedFile.new(csv_file_path, 'text/csv') }

  before do
    # Create a sample CSV file in the fixtures folder for testing
    File.open(csv_file_path, 'w') do |f|
      f.write("Product Number,Material,Form,Choice,Grade,Finish,Quantity,Weight (t),Location\n")
      f.write("12345678,Steel,Sheet,1st Choice,S355,Galvanized,10,25.5,US\n")
      f.write("87654321,Aluminum,Plate,2nd Choice,A1050,Anodized,5,10.0,DE\n")
    end
  end

  after do
    File.delete(csv_file_path) if File.exist?(csv_file_path)
  end

  describe 'POST #upload' do
    context 'with a valid CSV file' do
      it 'returns a success message' do
        post '/api/v1/inventories/upload', params: { file: file }

        parsed_response = JSON.parse(response.body)

        # Check that the response format matches `json_response`
        expect(parsed_response['data']['message']).to eq(ResponseMessages::SUCCESSFUL_UPLOAD)
      end

      it 'creates inventory items with correct attributes' do
        expect {
          post '/api/v1/inventories/upload', params: { file: file }
        }.to change { InventoryItem.count }.by(2)

        # Verify that the first inventory item was correctly created
        inventory_item = InventoryItem.find_by(product_number: '12345678')

        expect(inventory_item).not_to be_nil
        expect(inventory_item.material).to eq('Steel')
        expect(inventory_item.form).to eq('Sheet')
        expect(inventory_item.choice).to eq('1st Choice')
        expect(inventory_item.form_choice).to eq('Sheet 1st Choice')
        expect(inventory_item.grade).to eq('S355')
        expect(inventory_item.finish).to eq('Galvanized')
        expect(inventory_item.quantity).to eq(10)
        expect(inventory_item.weight.to_f).to eq(25.5)
        expect(inventory_item.location).to eq('US')
      end
    end

    context 'when CSV is malformed' do
      it 'returns an error message for malformed CSV' do
        allow(CSV).to receive(:foreach).and_raise(CSV::MalformedCSVError.new("Malformed CSV", nil))

        post '/api/v1/inventories/upload', params: { file: file }

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data']['message']).to eq("Invalid CSV format: Malformed CSV in line .")
      end
    end

    context 'with an invalid file format' do
      let(:invalid_file) { Rack::Test::UploadedFile.new(csv_file_path, 'application/json') }

      it 'returns an error message for invalid file format' do
        post '/api/v1/inventories/upload', params: { file: invalid_file }

        parsed_response = JSON.parse(response.body)
        expect(parsed_response['data']['message']).to eq(ResponseMessages::INVALID_FILE_FORMAT)
      end
    end
  end
end
