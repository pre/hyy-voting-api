class Token

  attr_accessor :token
  attr_accessor :user

  def initialize(token)
    self.token = token

    voter = Voter.first # TODO
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

  def details
    {
      goodToken: "from rails",
      faculty: {
        name: "Humanistinen Railskunta"
      },
      candidates: {
        url: "/mock_api/hum_tdk-candidates.json"
      },
      alliances: {
        url: "/mock_api/hum_tdk-alliances.json"
      }
    }
  end

end
