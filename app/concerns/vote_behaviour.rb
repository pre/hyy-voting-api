module VoteBehaviour
  extend ActiveSupport::Concern

  included do
    scope :by_election, -> (id) { where(election_id: id ) }
  end

  class_methods do

    # List candidates with sum of votes.
    #
    # If you inspect this method in Rails console, attributes are
    # not visible unless explicitly called, for example:
    # visible: `ImmutableVote.by_candidate.first.candidate_number`
    # not visible: `ImmutableVote.by_candidate.first.inspect`
    #
    # List all attributes:
    #   `ImmutableVote.by_candidate.first.attributes`
    #
    # NOTE:
    # - blank candidate (protest votes) will be ignored
    # - candidates without votes will be ignored (see `ImmutableVoteExport`)
    def by_candidate(election)
      select("
          candidates.candidate_number AS candidate_number,
          candidates.candidate_name   AS candidate_name,
          candidates.alliance_id      AS alliance_id,
          alliances.name              AS alliance_name,
          COUNT(*)                    AS vote_count")
        .joins("
          INNER JOIN candidates ON #{self.table_name}.candidate_id = candidates.id")
        .joins("
          INNER JOIN alliances  ON candidates.alliance_id          = alliances.id")
        .where(election_id: election.id)
        .where("candidates.candidate_number != #{Vaalit::Config::BLANK_CANDIDATE_NUMBER}")
        .group("
          candidate_number,
          candidate_name,
          alliance_id,
          alliance_name")
        .order("candidate_number")
    end
  end
end
