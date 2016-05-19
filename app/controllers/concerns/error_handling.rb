module ErrorHandling
  def expired_token
    render json: { error: "expired token, login again" }, status: 401
  end

  def not_authenticated
    render json: { error: "Not Authenticated. invalid or missing token" },
           status: 401
  end

  def invalid_endpoint
    render json: { error: "Invalid endpoint, check documentation"\
    " for more details" }, status: 400
  end
end
