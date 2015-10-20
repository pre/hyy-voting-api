class Department < ActiveRecord::Base
  has_many :elections

  belongs_to :faculty
end
