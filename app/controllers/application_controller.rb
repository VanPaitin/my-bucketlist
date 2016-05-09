class ApplicationController < ActionController::API
  before_filter :add_allow_credentials_headers
  include ActionController::Serialization
  def add_allow_credentials_headers
    response.headers["Access-Control-Allow-Origin"] = request.
                                                      headers["Origin"] || "*"
    response.headers["Access-Control-Allow-Credentials"] = "true"
  end

  def set_id
    params[:user][:id]
  end

  def get_token
    if request.headers["Authorization"].present?
      request.headers["Authorization"].split(" ").last
    end
  end

  def payload_token
    JWT.decode(get_token)
  end

  def current_user
    @current_user ||= User.find_by(id: payload_token[:user_id], logged_in: true)
  end

  def logged_in?
    !current_user.nil?
  end

  def ensure_login
    unless logged_in?
      render json: "Unauthorized Access", status: 403
    end
  end
end
