class Vote < ActiveRecord::Base
  belongs_to :voter
  belongs_to :candidate
  belongs_to :election

  validates_uniqueness_of :voter, null: false
  validates_presence_of :candidate_id,
                        :election_id,
                        :voter_id
end
