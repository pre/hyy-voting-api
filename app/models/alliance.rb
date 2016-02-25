class Alliance < ActiveRecord::Base
  include RankedModel
  ranks :numbering_order

  has_many :candidates, -> { order(candidate_number: :asc) }

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

  scope :by_election, -> (id) {
    where(election_id: id)
      .reorder(:numbering_order)
  }

end
