class Faculty < ActiveRecord::Base
  has_many :elections
  has_many :departments
end
