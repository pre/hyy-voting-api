class Department < ActiveRecord::Base
  has_many :elections

  belongs_to :faculty, optional: true

  validates_uniqueness_of :code
end
