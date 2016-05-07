class JsonWebToken
  def encode(payload)
    token = JWT.encode payload, key, 'HS256'
  end

  def decode(token)
    decoded_token = JWT.decode token, key,
      true, { :algorithm => 'HS256' }
  end
end