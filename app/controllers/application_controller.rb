class ApplicationController < ActionController::API
  before_filter :add_allow_credentials_headers
  include ActionController::Serialization
  def add_allow_credentials_headers
    response.headers["Access-Control-Allow-Origin"] = request.
                                                      headers["Origin"] || "*"
    response.headers["Access-Control-Allow-Credentials"] = "true"
  end

  def log_in(user)
    session[:user_id] = user.id
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id])
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
