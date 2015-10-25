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

  def elections
    [
      {
        id: 1,
        type: "faculty",
        name: "Humanistinen tiedekunta",
        candidates: {
          url: "http://localhost:3000/api/candidates"
        },
        alliances: {
          url: "http://localhost:3000/api/alliances?election_id=3"
        },
        voted_at: "2015-10-21"
      },
      {
        id: 2,
        type: "department",
        name: "Filosofian laitos",
        candidates: {
          url: "/mock_api/hum_tdk-candidates.json"
        },
        alliances: {
          url: "/mock_api/hum_tdk-alliances.json"
        },
        voted_at: nil
      },
      {
        id: 3,
        type: "college",
        name: "Kollegio (Humanistit)",
        candidates: {
          url: "/mock_api/hum_tdk-candidates.json"
        },
        alliances: {
          url: "/mock_api/hum_tdk-alliances.json"
        },
        voted_at: "2015-10-20"
      },
    ]

  end

end
