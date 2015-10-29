class Token

  attr_accessor :token

  # { voter_id: id }
  attr_accessor :user

  def initialize(token)
    self.token = token

    voter = Voter.first # TODO get according to token and do not crash if inexistant
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
