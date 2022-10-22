class Candidate < ActiveRecord::Base

  has_many :votes, class_name: 'ImmutableVote'

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

  validates_uniqueness_of :candidate_number

  scope :without_votes,
        -> { where("#{table_name}.id NOT IN (SELECT candidate_id FROM immutable_votes)") }

  scope :without_blank_candidate,
        -> { where("candidate_number != #{Vaalit::Config::BLANK_CANDIDATE_NUMBER}") }

end
