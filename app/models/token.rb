class Token
  include ExtendedPoroBehaviour

  # JWT token from the sign-in link
  attr_accessor :token

  # Payload of the JWT token from sign-in link
  attr_accessor :payload

  # { voter_id: id, email: email@example.com }
  attr_accessor :user

  validates_presence_of :payload

  # Decodes a JWT Token
  # Returns a token in array [payload, header]
  def self.decode(jwt)
    begin
      return JWT.decode jwt, Rails.application.secrets.jwt_secret
    rescue JWT::DecodeError
      return nil
    end
  end

  def initialize(token)
    self.token = token

    payload = Token.decode(token)

    if payload.nil?
      errors.add(:token, "Invalid token")
      return
    end

    voter = Voter.find_by_email payload # TODO get according to token and do not crash if inexistant
    self.user = {
      voter_id: voter.id,
      email: voter.email
    }
  end

  def valid?
    validate
  end

  def validate
    return false if token.blank? or user.blank?

    true
  end

  # TODO: Add token expiry
  def jwt
    JWT.encode user,
               Rails.application.secrets.jwt_secret,
               'HS256'
  end

  def elections
    Voter.find(user[:voter_id]).elections
  end

end
