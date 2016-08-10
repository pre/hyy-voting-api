# Processses the JWT token which is
# a) emailed to the user in the sign in link, or
# b) created when the user completes the Haka authentication.
#
# Provides the JWT token for API calls in @session_token.
#
# Sign in token is separate from the SessionToken. This allows independent
# expiry time for session JWT (stored in browser's SessionStorage) and
# sign in JWT (emailed to user or created after Haka auth).
class SignInTokenProcessor

  # SessionToken provides the JWT token to be used for API access by the user.
  attr_reader :session_token

  # Create a new Session Token to be used by the user to access the API.
  # A new JWT is generated in order to get a fresh expiry time.
  #
  # Params:
  # jwt => JWT Token from the emailed link or Haka authentication
  def initialize(jwt)
    @session_token = SessionToken.new Voter.find_by_email! get_email(jwt)
  end

  def valid?
    validate()
  end

  protected
  begin

    def validate
      @session_token && @session_token.valid?
    end

    # Retrieve email from the payload of the JWT token which was given in
    # the emailed sign-in link.
    #
    # Format:
    # [{"email"=>"testi.pekkanen@example.com"}, {"typ"=>"JWT", "alg"=>"HS256"}]
    def get_email(jwt_from_email)
      payload = JsonWebToken.decode jwt_from_email

      if payload.nil?
        errors.add(:session_token, "Invalid source JWT token in the email link")
        return
      end

      payload.first["email"]
    end

  end
end
