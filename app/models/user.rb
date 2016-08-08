# Represents the API user who has access to the voting
class User

  attr_reader :voter

  def initialize(voter)
    @voter = voter
  end

  def voter_id
    @voter.id
  end

  def email
    @voter.email
  end
end
