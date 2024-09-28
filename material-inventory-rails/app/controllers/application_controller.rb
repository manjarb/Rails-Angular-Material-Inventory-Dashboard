class ApplicationController < ActionController::API
  def json_response(data, status = :ok)
    render json: {
      data: data,
      timestamp: Time.now.to_i
    }, status: status
  end
end
