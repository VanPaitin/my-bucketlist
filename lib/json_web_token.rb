class JsonWebToken
  class << self
    def encode(payload)
      payload[:exp] = 2.days.from_now.to_i
      JWT.encode payload, secret, "HS512"
    end

    def decode(token)
      payload = JWT.decode token, secret, true, algorithm: "HS512"
      HashWithIndifferentAccess.new payload[0]
    end

    def secret
      Rails.application.secrets.secret_key_base
    end
  end
end
