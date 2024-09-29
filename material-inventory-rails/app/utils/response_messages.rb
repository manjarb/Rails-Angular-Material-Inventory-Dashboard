module ResponseMessages
  SUCCESSFUL_UPLOAD = 'File uploaded and data persisted successfully'.freeze
  INVALID_FILE_FORMAT = 'Invalid file format. Please upload a CSV file.'.freeze
  PROCESSING_ERROR = ->(error) { "Failed to process file: #{error}" }
  CSV_PARSE_ERROR = ->(error) { "Invalid CSV format: #{error}" }
end
