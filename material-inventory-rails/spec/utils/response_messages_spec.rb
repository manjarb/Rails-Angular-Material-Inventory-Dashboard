require 'rails_helper'

RSpec.describe ResponseMessages do
  describe 'SUCCESSFUL_UPLOAD' do
    it 'returns the correct success message' do
      expect(ResponseMessages::SUCCESSFUL_UPLOAD).to eq('File uploaded and data persisted successfully')
    end
  end

  describe 'INVALID_FILE_FORMAT' do
    it 'returns the correct invalid file format message' do
      expect(ResponseMessages::INVALID_FILE_FORMAT).to eq('Invalid file format. Please upload a CSV file.')
    end
  end

  describe 'PROCESSING_ERROR' do
    let(:error_message) { 'unexpected error occurred' }

    it 'returns the correct processing error message with the error details' do
      expect(ResponseMessages::PROCESSING_ERROR.call(error_message)).to eq("Failed to process file: #{error_message}")
    end
  end

  describe 'CSV_PARSE_ERROR' do
    let(:csv_error_message) { 'malformed CSV content' }

    it 'returns the correct CSV parse error message with the error details' do
      expect(ResponseMessages::CSV_PARSE_ERROR.call(csv_error_message)).to eq("Invalid CSV format: #{csv_error_message}")
    end
  end
end
