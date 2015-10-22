class Candidate < ActiveRecord::Base
  has_many :votes

  belongs_to :alliance
end
