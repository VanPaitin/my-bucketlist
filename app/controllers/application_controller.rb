class ApplicationController < ActionController::API
  before_filter :add_allow_credentials_headers
  before_action :ensure_login
  include ActionController::Serialization
  rescue_from ExpirationError, with: :expired_token
  rescue_from NotAuthenticatedError, with: :not_authenticated

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
    if params_integrity?
      current_user.id
    else
      head 403
    end
  end

  def params_integrity?
    current_user.id == params[:id].to_i
  end

  def get_token
    if request.headers["Authorization"].present?
      request.headers["Authorization"].split(" ").last
    end
  end

  def payload_token
    JsonWebToken.decode(get_token)
  rescue JWT::ExpiredSignature
    raise ExpirationError
  rescue JWT::VerificationError, JWT::DecodeError
    raise NotAuthenticatedError
  rescue
    nil
  end

  def current_user
    if payload_token
      @current_user ||= User.find_by(id: payload_token[:user_id],
                                   logged_in: true)
    end
  end

  def logged_in?
    current_user.present?
  end

  def ensure_login
    head 401 unless logged_in?
  end

  def expired_token
    render json: { error: "expired token, login again" }, status: 401
  end

  def not_authenticated
    render json: { error: "Not Authenticated. invalid or missing token" },
           status: 401
  end
end
