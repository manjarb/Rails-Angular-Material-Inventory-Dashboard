require 'csv'

class Api::V1::PreferencesController < ApplicationController
  BATCH_SIZE = 100

  # POST /api/v1/preferences/upload
  def upload
    file = params[:file]

    if file && file.content_type == 'text/csv'
      begin
        preference_items = []

        Preference.transaction do
          CSV.foreach(file.path, headers: true) do |row|
            # Normalize headers using the utility
            normalized_row = CsvUtils.normalize_preference_headers(row)

            preference_items << normalized_row

            if preference_items.size >= BATCH_SIZE
              Preference.insert_all(preference_items)
              preference_items.clear  # Clear the array for the next batch
            end
          end

          # Insert remaining records if any are left after the loop
          Preference.insert_all(preference_items) if preference_items.any?
        end

        # Use the service to find exact matches
        matches = PreferenceService.find_matches

        json_response(matches)
      rescue StandardError => e
        json_response({ message: ResponseMessages::PROCESSING_ERROR.call(e.message) }, :unprocessable_entity)
      end
    else
      json_response({ message: ResponseMessages::INVALID_FILE_FORMAT }, :unprocessable_entity)
    end
  end

  # GET /api/v1/preferences
  def index
    preferences = Preference.all
    json_response(preferences)
  end
end
