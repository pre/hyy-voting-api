# Represents the information stored in the JWT session token which
# is submitted by the user-agent to Voting-API.
class SessionToken

  # User who is signed in.
  attr_reader :user

  # Params:
  # voter => an instance of `Voter` who is to be signed in
  def initialize(voter)
    @user = User.new voter
  end

  def valid?
    validate
  end

  # JWT used for API access.
  def jwt
    payload = {
      voter_id: @user.voter.id,
      email: @user.voter.email
    }

    JsonWebToken.encode payload, Rails.application.secrets.jwt_voter_secret
  end

  # List of elections displayed in frontpage.
  # User can vote in multiple elections in administration elections (Halloped).
  def elections
    @user.voter.elections
  end

  # Voter's own info.
  # Displayed in "check your eligibility" page.
  def voter
    @user.voter
  end

  protected
  begin

    def validate
      not user.blank?
    end

  end

end
