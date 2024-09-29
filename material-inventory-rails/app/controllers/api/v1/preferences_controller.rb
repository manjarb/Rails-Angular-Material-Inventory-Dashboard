require 'csv'

class Api::V1::PreferencesController < ApplicationController
  DEFAULT_PAGE = 1
  DEFAULT_LIMIT = 20
  DEFAULT_WEIGHT = 10

  # POST /api/v1/preferences/upload
  def upload
    file = params[:file]

    if file && file.content_type == 'text/csv'
      begin
        # Use service to handle file processing and insertion
        new_preferences = PreferenceService.upload_preferences(file)

        # Fetch pagination parameters from query params or use defaults
        pagination = PaginationUtils.extract_pagination_params(params, DEFAULT_PAGE, DEFAULT_LIMIT)
        page = pagination[:page]
        limit = pagination[:limit]
        weight = params[:weight].to_i > 0 ? params[:weight].to_i : DEFAULT_WEIGHT

        # Use the service to find exact matches
        matches = PreferenceService.find_matches(new_preferences, page: page, per_page: limit, weight: weight)

        response = {
          items: matches.items.map{ |item| InventoryService.serialize_inventory_item(item) },
          meta: PaginationUtils.pagination_meta(matches, limit)
        }

        json_response(response)
      rescue CSV::MalformedCSVError => e
        json_response({ message: ResponseMessages::CSV_PARSE_ERROR.call(e.message) }, :unprocessable_entity)
      rescue StandardError => e
        json_response({ message: ResponseMessages::PROCESSING_ERROR.call(e.message) }, :unprocessable_entity)
      end
    else
      json_response({ message: ResponseMessages::INVALID_FILE_FORMAT }, :unprocessable_entity)
    end
  end

  # GET /api/v1/preferences
  def index
    pagination = PaginationUtils.extract_pagination_params(params, DEFAULT_PAGE, DEFAULT_LIMIT)
    page = pagination[:page]
    limit = pagination[:limit]

    preferences = Preference.page(page).per(limit)
    response = {
      items: preferences.map(&:attributes),
      meta: PaginationUtils.pagination_meta(preferences, limit)
    }
    json_response(response)
  end
end
