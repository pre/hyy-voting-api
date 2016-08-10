class JsonWebToken

  # Encoded a JWT Token.
  # `payload` is expected in JSON format.
  # `exp` sets default expiry time.
  def self.encode(payload, exp = Vaalit::Config::SESSION_JWT_EXPIRY_MINUTES.from_now)
    payload[:exp] = exp.to_i

    JWT.encode payload,
               Rails.application.secrets.jwt_secret,
               'HS256'
  end

  # Decodes a JWT Token
  # Returns a token in array [payload, header]
  def self.decode(jwt)
    begin
      return JWT.decode jwt, Rails.application.secrets.jwt_secret
    rescue JWT::DecodeError, JWT::ExpiredSignature
      return nil
    end
  end
end
