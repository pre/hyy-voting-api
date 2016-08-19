class MutableVote < ActiveRecord::Base
  include VoteBehaviour

  belongs_to :voter
  belongs_to :candidate
  belongs_to :election

  validates_uniqueness_of :voter,
                              null: false,
                              scope: :election_id

  validates_presence_of :candidate_id,
                        :election_id,
                        :voter_id

  validate :candidate_belongs_to_election

  def self.update_or_create_by(voter_id:, election_id:, candidate_id:)
    existing = self.find_by_voter_id_and_election_id voter_id, election_id

    if existing.present?
      existing.candidate_id = candidate_id
      existing.save

      return existing
    else
      return self.create voter_id: voter_id,
                         election_id: election_id,
                         candidate_id: candidate_id
    end
  end

  protected

  def candidate_belongs_to_election
    Election.find(election_id).candidates.find(candidate_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:candidate, "Candidate #{candidate_id} does not belong to election #{election_id}")
    nil
  end
end
