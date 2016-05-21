module ErrorHandling
  def expired_token
    render json: { error: language.expired_token }, status: 401
  end

  def not_authenticated
    render json: { error: language.not_authenticated },
           status: 401
  end

  def invalid_endpoint
    render json: { error: language.invalid_endpoint }, status: 400
  end
end
