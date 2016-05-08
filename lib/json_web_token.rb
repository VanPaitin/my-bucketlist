class JsonWebToken
  class << self
    def encode(payload)
      payload[:exp] = 2.days.from_now.to_i
      token = JWT.encode payload, Rails.application.secrets.secret_key_base,
        'HS512'
    end

    def decode(token)
      payload = JWT.decode token, Rails.application.secrets.secret_key_base,
        true, { :algorithm => 'HS512' }[0]
      HashWithIndifferentAccess.new payload
    rescue
      nil
    end
  end
end