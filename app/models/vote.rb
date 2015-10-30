class Vote < ActiveRecord::Base
  belongs_to :voter
  belongs_to :candidate

  validates_uniqueness_of :voter, nulL: false
  validates_presence_of :candidate_id
end
