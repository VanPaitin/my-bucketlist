module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from ExpirationError, with: :expired_token
    rescue_from NotAuthenticatedError, with: :not_authenticated
  end

  def expired_token
    render json: { error: language.expired_token }, status: 401
  end

  def not_authenticated
    render json: { error: language.not_authenticated }, status: 401
  end

  def invalid_endpoint
    render json: { error: language.invalid_endpoint }, status: 400
  end
end
