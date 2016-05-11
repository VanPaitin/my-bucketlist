class ApplicationController < ActionController::API
  before_filter :add_allow_credentials_headers
  include ActionController::Serialization

  private

  def serialization_scope
    false
  end

  def add_allow_credentials_headers
    response.headers["Access-Control-Allow-Origin"] = request.
                                                      headers["Origin"] || "*"
    response.headers["Access-Control-Allow-Credentials"] = "true"
  end

  def set_id
    binding.pry
    head 403 unless params_integrity
    current_user.id
  end

  def params_integrity
    current_user.id == params[:id].to_i
  end

  def get_token
    if request.headers["Authorization"].present?
      request.headers["Authorization"].split(" ").last
    end
  end

  def payload_token
    JsonWebToken.decode(get_token)
  end

  def current_user
    @current_user ||= User.find_by(id: payload_token[:user_id], logged_in: true
      )
  rescue
    nil
  end

  def logged_in?
    !current_user.nil?
  end

  def ensure_login
    unless logged_in?
      head 403
    end
  end
end
