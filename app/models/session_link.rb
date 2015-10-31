class SessionLink
  include ExtendedPoroBehaviour

  attr_accessor :email,
                :voter

  before_validation :assign_voter
  validate :voter_exists?

  validates_presence_of :email

  def deliver
    return false unless valid?

    SessionLinkMailer.signup_link(voter.email, url).deliver_now
  end

  protected

  def voter_exists?
    if voter.blank?
      errors.add(:email, "Given email doesn't have any elections")
      return false
    end

    return true
  end

  def assign_voter
    self.voter = Voter.find_by_email(email)
  end

  private

  # TODO: Add token expiry
  def jwt
    JWT.encode email,
               Rails.application.secrets.jwt_secret,
               'HS256'
  end

  def url
    "#{Vaalit::Public::SITE_ADDRESS}/#/sign-in?token=#{URI.encode(jwt)}"
  end
end
