class ImmutableVote < ApplicationRecord
  include VoteBehaviour

  belongs_to :candidate
  belongs_to :election

  validates_presence_of :candidate_id,
                        :election_id

end
