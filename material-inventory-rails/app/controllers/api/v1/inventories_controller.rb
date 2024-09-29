require 'csv'

class Api::V1::InventoriesController < ApplicationController
  # Define the batch size (can be increased for better performance)
  BATCH_SIZE = 100
  DEFAULT_PAGE = 1
  DEFAULT_LIMIT = 20

  # POST /api/v1/inventories/upload
  def upload
    file = params[:file]

    if file && file.content_type == 'text/csv'
      begin
        InventoryService.process_file(file)
        json_response({ message: ResponseMessages::SUCCESSFUL_UPLOAD })
      rescue CSV::MalformedCSVError => e
        json_response({ message: ResponseMessages::CSV_PARSE_ERROR.call(e.message) }, :unprocessable_entity)
      rescue StandardError => e
        json_response({ message: ResponseMessages::PROCESSING_ERROR.call(e.message) }, :unprocessable_entity)
      end
    else
      json_response({ message: ResponseMessages::INVALID_FILE_FORMAT }, :unprocessable_entity)
    end
  end

  # GET /api/v1/inventories
  def index
    # Extract pagination parameters
    pagination = PaginationUtils.extract_pagination_params(params, DEFAULT_PAGE, DEFAULT_LIMIT)
    page = pagination[:page]
    limit = pagination[:limit]

    # Define allowed columns and directions for sorting
    allowed_sort_columns = %w[weight form_choice]
    allowed_sort_directions = %w[asc desc]

    sort_column = params[:sort_column].presence_in(allowed_sort_columns) || 'weight'
    sort_direction = params[:sort_direction].presence_in(allowed_sort_directions) || 'desc'

    # Fetch paginated inventory items
    inventories = InventoryItem.order("#{sort_column} #{sort_direction}").page(page).per(limit)

    # Prepare response
    response = {
      items: inventories.map{ |item| InventoryService.serialize_inventory_item(item) },
      meta: PaginationUtils.pagination_meta(inventories, limit)
    }

    json_response(response)
  end

  # GET /api/v1/inventories/summary
  def summary
    total_line_items = InventoryItem.count
    total_volume_tons = InventoryItem.sum(:weight)

    json_response({
      total_line_items: total_line_items,
      total_volume_tons: total_volume_tons
    })
  end
end
