class Alliance < ActiveRecord::Base
  include RankedModel
  ranks :numbering_order

  has_many :candidates

  belongs_to :election
  belongs_to :faculty
  belongs_to :department

  validates_presence_of :election_id

  validates :faculty_id, presence: {
    if: Proc.new { |a| a.department_id.blank? },
    message: 'Either faculty or department is required.'
  }

  validates :department_id, presence: {
    if: Proc.new { |a| a.faculty_id.blank? },
    message: 'Either faculty or department is required.'
  }

end
