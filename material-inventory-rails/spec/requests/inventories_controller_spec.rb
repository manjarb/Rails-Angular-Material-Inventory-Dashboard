require 'rails_helper'

RSpec.describe Api::V1::InventoriesController, type: :controller do
  let(:csv_file_path) { Rails.root.join('spec', 'inventory.csv') }
  let(:valid_csv) { Rack::Test::UploadedFile.new(csv_file_path, 'text/csv') }
  let(:invalid_csv) { Rack::Test::UploadedFile.new(csv_file_path, 'text/plain') }

  before do
    # Create a sample CSV file in the fixtures folder for testing
    File.open(csv_file_path, 'w') do |f|
      f.write("Product Number,Material,Form,Choice,Grade,Finish,Surface,Quantity,Weight (t),Length (mm),Width (mm),Height (mm),Thickness (mm),Outer Diameter (mm),Wall Thickness (mm),Web Thickness (mm),Flange Thickness (mm),Certificates,Location\n")
      f.write("12345678,Steel,Sheet,1st Choice,S355,Galvanized,O,10,25.5,1000,500,200,10,300,,5,2,Cert123,US\n")
    end
  end

  after do
    File.delete(csv_file_path) if File.exist?(csv_file_path)
  end

  describe 'POST #upload' do
    context 'with a valid CSV file' do
      it 'returns a success message' do
        post :upload, params: { file: valid_csv }
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)['data']['message']).to eq(ResponseMessages::SUCCESSFUL_UPLOAD)
      end
    end

    context 'with an invalid CSV file type' do
      it 'returns an error message for invalid file format' do
        post :upload, params: { file: invalid_csv }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['data']['message']).to eq(ResponseMessages::INVALID_FILE_FORMAT)
      end
    end

    context 'when CSV is malformed' do
      before do
        allow(CSV).to receive(:foreach).and_raise(CSV::MalformedCSVError.new("Malformed CSV", nil))
      end

      it 'returns an error message for malformed CSV' do
        post :upload, params: { file: valid_csv }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['data']['message']).to include("Invalid CSV format")
      end
    end

    context 'when an unexpected error occurs' do
      before do
        allow(InventoryService).to receive(:process_file).and_raise(StandardError.new("Unexpected error"))
      end

      it 'returns a processing error message' do
        post :upload, params: { file: valid_csv }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(JSON.parse(response.body)['data']['message']).to include("Failed to process file")
      end
    end
  end

  describe 'GET #index' do
    let!(:inventory_items) { create_list(:inventory_item, 5, weight: 10) }

    it 'returns a paginated list of inventory items' do
      get :index, params: { page: 1, limit: 2 }
      expect(response).to have_http_status(:ok)

      response_data = JSON.parse(response.body)
      expect(response_data['data']['items'].length).to eq(2)
      expect(response_data['data']['meta']['current_page']).to eq(1)
      expect(response_data['data']['meta']['total_pages']).to eq(3)
      expect(response_data['data']['meta']['total_count']).to eq(5)
    end

    it 'applies default sorting by weight descending' do
      get :index
      response_data = JSON.parse(response.body)
      items = response_data['data']['items']
      expect(items[0]['weight']).to be >= items[1]['weight']
    end

    it 'applies sorting based on form_choice in ascending order' do
      get :index, params: { sort_column: 'form_choice', sort_direction: 'asc' }
      response_data = JSON.parse(response.body)
      items = response_data['data']['items']
      expect(items[0]['form_choice']).to be <= items[1]['form_choice']
    end
  end

  describe 'GET #summary' do
    let!(:inventory_items) { create_list(:inventory_item, 3, weight: 20) }

    it 'returns the total number of line items and total volume' do
      get :summary
      expect(response).to have_http_status(:ok)

      response_data = JSON.parse(response.body)
      expect(response_data['data']['total_line_items']).to eq(3)
      expect(response_data['data']['total_volume_tons']).to eq("60.0")
    end
  end
end
