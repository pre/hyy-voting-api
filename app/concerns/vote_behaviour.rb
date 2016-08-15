# Shared behaviour between MutableVote and ImmutableVote
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
    # visible: `Vote.by_candidate.first.candidate_number`
    # not visible: `Vote.by_candidate.first.inspect`
    def by_candidate
      select("
          candidates.candidate_number AS candidate_number,
          candidates.alliance_id      AS alliance_id,
          candidates.candidate_name   AS candidate_name,
          COUNT(*)                    AS vote_count")
        .joins("
          INNER JOIN candidates ON votes.candidate_id = candidates.id")
        .group("
          candidate_number,
          alliance_id,
          candidate_name")
        .order("candidate_number")
    end
  end
end
