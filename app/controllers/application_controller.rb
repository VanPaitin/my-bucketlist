class ApplicationController < ActionController::API
  before_filter :add_allow_credentials_headers
  before_action :ensure_login, except: :invalid_endpoint
  include ActionController::Serialization
  include ErrorHandling
  rescue_from ExpirationError, with: :expired_token
  rescue_from NotAuthenticatedError, with: :not_authenticated

  private

  def serialization_scope
    false
  end

  def language
    @language ||= Languages.new
  end

  def add_allow_credentials_headers
    response.headers["Access-Control-Allow-Origin"] = request.
                                                      headers["Origin"] || "*"
    response.headers["Access-Control-Allow-Credentials"] = "true"
  end

  def issue_token
    @user.update_attribute(:logged_in, true)
    JsonWebToken.encode user_id: @user.id
  end

  def set_id
    if params_integrity?
      current_user.id
    else
      render json: { forbidden: language.forbidden },
             status: 403
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
    if payload_token
      @current_user ||= User.find_by(id: payload_token[:user_id],
                                     logged_in: true)
    end
  end

  def logged_in?
    current_user.present?
  end

  def ensure_login
    unless logged_in?
      render json: { Unauthorized: language.unauthorized },
             status: 401 unless logged_in?
    end
  end
end
