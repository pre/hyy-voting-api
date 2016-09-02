class ElectionSummary

  def initialize(election)
    @election = election
  end

  def voting_percentage
    return 0.0 if votes_given.zero?

    (100.0 * votes_given / voter_count).round 2
  end

  def votes_given
    @election.immutable_votes.count
  end

  def voter_count
    @election.voters.count
  end

  def votes_accepted
    votes_given - blank_votes
  end

  def blank_votes
    blank_candidate = @election
                      .candidates
                      .find_by_candidate_number!(
                        Vaalit::Config::BLANK_CANDIDATE_NUMBER
                      )

    @election
      .candidates
      .find(blank_candidate.id)
      .votes
      .count
  end

  def candidate_count
    @election
      .candidates
      .without_blank_candidate
      .count
  end
end
