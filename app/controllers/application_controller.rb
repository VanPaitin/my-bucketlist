class ApplicationController < ActionController::API
  before_action :add_allow_credentials_headers
  before_action :ensure_login, except: :invalid_endpoint
  include ActionController::Serialization
  include ErrorHandling

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
