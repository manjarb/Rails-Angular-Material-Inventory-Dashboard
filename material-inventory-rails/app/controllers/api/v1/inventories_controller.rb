require 'csv'

class Api::V1::InventoriesController < ApplicationController
  # Define the batch size (can be increased for better performance)
  BATCH_SIZE = 100

  # POST /api/v1/inventories/upload
  def upload
    file = params[:file]

    if file && file.content_type == 'text/csv'
      begin
        InventoryService.process_file(file)
        json_response({ message: ResponseMessages::SUCCESSFUL_UPLOAD })
      rescue StandardError => e
        json_response({ message: ResponseMessages::PROCESSING_ERROR.call(e.message) }, :unprocessable_entity)
      end
    else
      json_response({ message: ResponseMessages::INVALID_FILE_FORMAT }, :unprocessable_entity)
    end
  end

  # GET /api/v1/inventories
  def index
    inventories = InventoryItem.all
    render json: inventories, status: :ok
  end
end
