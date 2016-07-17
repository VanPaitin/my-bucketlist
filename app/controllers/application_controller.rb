class ApplicationController < ActionController::API
  before_action :add_allow_credentials_headers
  before_action :ensure_login, except: :invalid_endpoint
  before_filter :cors_preflight_check
  after_filter :cors_set_access_control_headers
  include ActionController::Serialization
  include ErrorHandling

  def cors_set_access_control_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
    headers['Access-Control-Allow-Headers'] = 'Origin, Content-Type, Accept, Authorization, Token'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def cors_preflight_check
    if request.method == 'OPTIONS'
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, PUT, DELETE, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'Origin, X-Requested-With, Content-Type, X-Prototype-Version, Token'
      headers['Access-Control-Max-Age'] = '1728000'
    end
  end

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

  def current_user
    token = request.headers["Authorization"]
    if token
      @current_user ||= User.find_by(
        id: JsonWebToken.payload_token(token)[:user_id],
        logged_in: true
      )
    else
      raise NotAuthenticatedError
    end
  end

  def ensure_login
    current_user.present?
  end
end
