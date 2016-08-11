class Candidate < ActiveRecord::Base

  has_many :votes

  belongs_to :alliance

  has_one :faculty, through: :alliance
  has_one :department, through: :alliance

  validates_presence_of :alliance_id,
                        :firstname,
                        :lastname,
                        :candidate_name,
                        :candidate_number

  validates_uniqueness_of :candidate_number,
                          if: Proc.new { Vaalit::Config::IS_SINGLE_ELECTION }


end
