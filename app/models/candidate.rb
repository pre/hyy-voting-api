class Candidate < ActiveRecord::Base

  has_many :votes, class_name: "ImmutableVote"  if Vaalit::Config::IS_EDARI_ELECTION
  has_many :votes, class_name: "MutableVote"    if Vaalit::Config::IS_HALLOPED_ELECTION

  belongs_to :alliance

  has_one :election, through: :alliance
  has_one :coalition, through: :alliance

  has_one :faculty, through: :alliance
  has_one :department, through: :alliance

  validates_presence_of :alliance_id,
                        :firstname,
                        :lastname,
                        :candidate_name,
                        :candidate_number

  validates_uniqueness_of :candidate_number,
                          if: Proc.new { Vaalit::Config::IS_EDARI_ELECTION }

  #TODO: support mutable_votes
  scope :without_votes,
        -> { Candidate.where("#{table_name}.id NOT IN (SELECT candidate_id FROM immutable_votes)") }

  scope :without_blank_candidate,
        -> { Candidate.where("candidate_number != #{Vaalit::Config::BLANK_CANDIDATE_NUMBER}") }

end
