class Vote < ActiveRecord::Base
  belongs_to :voter
  belongs_to :candidate
  belongs_to :election

  validates_uniqueness_of :voter, null: false, scope: :election_id

  validates_presence_of :candidate_id,
                        :election_id,
                        :voter_id

  validate :candidate_belongs_to_election

  scope :by_election, -> (id) { where(election_id: id ) }

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

  def self.by_candidate
    select("
        candidates.candidate_number AS candidate_number,
        candidates.alliance_id AS alliance_id,
        candidates.candidate_name AS candidate_name,
        COUNT(*) AS vote_count")
      .joins("INNER JOIN candidates ON votes.candidate_id = candidates.id")
      .group("
        candidate_number,
        alliance_id,
        candidate_name")
      .order("candidate_number")
  end

  protected

  def candidate_belongs_to_election
    Election.find(election_id).candidates.find(candidate_id)
  rescue ActiveRecord::RecordNotFound
    errors.add(:candidate, "Candidate #{candidate_id} does not belong to election #{election_id}")
    nil
  end
end
