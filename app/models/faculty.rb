class Faculty < ActiveRecord::Base
  has_many :elections
  has_many :departments

  validates_uniqueness_of :code
end
