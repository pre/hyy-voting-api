class Election < ActiveRecord::Base
  has_many :alliances
  belongs_to :faculty
end
