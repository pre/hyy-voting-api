class SessionLink
  include ExtendedPoroBehaviour

  attr_accessor :email

  validates_presence_of :email

  # TODO: Add token expiry
  def jwt
    JWT.encode email,
               Rails.application.secrets.jwt_secret,
               'HS256'
  end

  def deliver
    return false unless valid?

    true
  end
end
