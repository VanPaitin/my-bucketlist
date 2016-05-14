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

  def query_conditions(controller = params[:controller])
    bucketlist_id = if controller == "api/v1/items"
                      params[:bucketlist_id]
                    elsif controller == "api/v1/bucketlists"
                      params[:id]
                    end
    { id: bucketlist_id, user_id: current_user.id }
  end

  def set_bucketlist
    @bucketlist = Bucketlist.find_by(query_conditions)
    if @bucketlist
      @bucketlist
    else
      render json: { null: "no bucketlist found" }, status: 404
    end
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
  end

  def current_user
    @current_user ||= User.find_by(id: payload_token[:user_id],
                                   logged_in: true)
  rescue
    nil
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
