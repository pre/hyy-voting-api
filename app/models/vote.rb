class Vote < ActiveRecord::Base
  belongs_to :voter
  belongs_to :candidate
  belongs_to :election

  validates_uniqueness_of :voter, null: false
  validates_presence_of :candidate_id,
                        :election_id,
                        :voter_id

  scope :by_election, -> (id) { where(election_id: id ) }

  def self.update_or_create_by(opts)
    voter_id = opts[:voter_id]
    election_id = opts[:election_id]
    candidate_id = opts[:candidate_id]

    existing = self.find_by_voter_id voter_id

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
end
