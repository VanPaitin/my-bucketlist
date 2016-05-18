module ErrorHandling
  def expired_token
    render json: { error: "expired token, login again" }, status: 401
  end

  def not_authenticated
    render json: { error: "Not Authenticated. invalid or missing token" },
           status: 401
  end

  def wrong_parameters
    render json: { error: "Missing or wrong parameters, see docs for details" },
           status: 400
  end
end
