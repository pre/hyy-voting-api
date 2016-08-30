class JsonWebToken

  # Encoded a JWT Token.
  # `payload` is expected in JSON format.
  # `exp` sets default expiry time.
  def self.encode(payload,
                  secret,
                  exp = Vaalit::Config::VOTER_SESSION_JWT_EXPIRY_MINUTES.from_now)

    payload[:exp] = exp.to_i

    JWT.encode payload, secret, 'HS256'
  end

  # Decodes a JWT Token
  # Returns a token in array [payload, header]
  def self.decode(jwt, secret)
    begin
      return JWT.decode jwt, secret
    rescue JWT::DecodeError, JWT::ExpiredSignature => e
      Rails.logger.info "JWT: DecodeError or ExpiredSignature: #{e.message}"
      return nil
    end
  end
end
