# Processses the JWT token which is emailed to the user in the sign in link.
# Provides the JWT token for API calls in @session_token.
#
# Future work:
# JWT token in the sign in link could use a different secret than the actual API
# access token. Currently the JWT token in the sign in link can be also used to
# access the API.
class EmailTokenProcessor

  # SessionToken provides the JWT token to be used for API access by the user.
  attr_reader :session_token

  # Create a new Session Token according to the JWT which was delivered
  # to the user in the email link.
  #
  # Params:
  # jwt => JWT Token from the emailed link
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

    # Retrieve email fro mthe payload of the JWT token which was given in
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
