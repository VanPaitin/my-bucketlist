class ApplicationController < ActionController::API
  before_filter :add_allow_credentials_headers

  def add_allow_credentials_headers
    response.headers["Access-Control-Allow-Origin"] = request.
                                                      headers["Origin"] || "*"
    response.headers["Access-Control-Allow-Credentials"] = "true"
  end

  def ensure_login
    unless logged_in?
      render json: "Unauthorized Access", status: 403
    end
  end
end
