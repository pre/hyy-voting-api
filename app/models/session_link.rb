class SessionLink
  include ExtendedPoroBehaviour

  attr_accessor :email

  validates_presence_of :email

  def deliver
    return false unless valid?

    voter = Vote.find_by_email email
    return false unless voter.present?

    SessionLinkMailer.signup_link(voter.email, url).deliver_now
  end

  private

  # TODO: Add token expiry
  def jwt
    JWT.encode email,
               Rails.application.secrets.jwt_secret,
               'HS256'
  end

  def url
    "#{Vaalit::Public::SITE_ADDRESS}/#/sign-in?token=#{jwt}"
  end
end
