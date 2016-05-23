class JsonWebToken
  class << self
    def encode(payload, exp = 2.days.from_now.to_i)
      payload[:exp] = exp
      JWT.encode payload, secret, "HS512"
    end

    def decode(token)
      payload = JWT.decode token, secret, true, algorithm: "HS512"
      HashWithIndifferentAccess.new payload[0]
    end

    def secret
      Rails.application.secrets.secret_key_base
    end

    def issue_token(user)
      user.update_attribute(:logged_in, true)
      encode user_id: user.id
    end

    def payload_token(token)
      decode token
    rescue JWT::ExpiredSignature
      raise ExpirationError
    rescue JWT::VerificationError, JWT::DecodeError
      raise NotAuthenticatedError
    end
  end
end
