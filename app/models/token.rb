
# TODO: This class is more like a "client session" instead of "token".
# - Session API returns Entity `Token` having attrs elections, jwt, user, voter
# based on this class.
class Token
  include ExtendedPoroBehaviour

  # JWT token from the sign-in link
  attr_accessor :token

  # Payload of the JWT token from sign-in link
  # Format:
  # [{"email"=>"testi.pekkanen@example.com"}, {"typ"=>"JWT", "alg"=>"HS256"}]
  attr_accessor :payload

  # Format:
  # { voter_id: id, email: email@example.com }
  attr_accessor :user

  attr_accessor :voter

  validates_presence_of :payload

  def initialize(token)
    self.token = token
    self.payload = JsonWebToken.decode(token)

    if payload.nil?
      errors.add(:token, "Invalid token")
      return
    end

    self.voter = Voter.find_by_email! payload.first["email"]

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

  def jwt
    JsonWebToken.encode user
  end

  def elections
    Voter.find(user[:voter_id]).elections
  end

end
