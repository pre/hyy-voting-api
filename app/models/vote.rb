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
        candidates.candidate_number AS number,
        candidates.alliance_id AS alliance_id,
        candidates.firstname AS firstname,
        candidates.lastname AS lastname,
        candidates.spare_firstname AS spare_firstname,
        candidates.spare_lastname AS spare_lastname,
        COUNT(*) AS vote_count")
      .joins("INNER JOIN candidates ON votes.candidate_id = candidates.id")
      .group("
        number,
        alliance_id,
        firstname,
        lastname,
        spare_firstname,
        spare_lastname")
      .order("number")
  end

  def self.to_csv
    votes = Vote.by_candidate

    csv = "ehdokasnumero,vaaliliitto,etunimi,sukunimi,varan etunimi,varan sukunimi,ääniä\n"

    votes.each do |v|
      csv << "#{v.number},#{v.alliance_id},#{v.firstname},#{v.lastname},#{v.spare_firstname},#{v.spare_lastname},#{v.vote_count}\n"
    end

    csv
  end

  protected

  def candidate_belongs_to_election
    begin
      Election.find(election_id).candidates.find(candidate_id)
    rescue ActiveRecord::RecordNotFound
      errors.add(:candidate, "Candidate #{candidate_id} does not belong to election #{election_id}")
    end
  end
end
