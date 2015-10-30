class Vote < ActiveRecord::Base
  belongs_to :voter
  belongs_to :candidate
  belongs_to :election

  validates_uniqueness_of :voter, nulL: false
  validates_presence_of :candidate_id
end
