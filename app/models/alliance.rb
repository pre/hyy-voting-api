class Alliance < ActiveRecord::Base
  include RankedModel

  belongs_to :coalition
  belongs_to :election

  # Faculty and department are significant only in Halloped elections
  belongs_to :faculty
  belongs_to :department

  ranks :numbering_order
  # ranks :numbering_order, :with_same => :coalition_id
  # scope :by_numbering_order, order("#{table_name}.numbering_order")

  has_many :candidates, -> { order(candidate_number: :asc) }

  validates_presence_of :election_id,
                        :name,
                        :short_name

  validates_uniqueness_of :short_name,
                          :name

  validates_length_of :short_name, :in => 2..6

  # In Halloped elections,
  # voting right is determined according to faculty or deparment
  validates :faculty_id, presence: {
    if: Proc.new { |a| a.election.halloped? && a.department_id.blank? },
    message: 'Either faculty or department is required.'
  }

  # In Halloped elections,
  # voting right is determined according to faculty or deparment
  validates :department_id, presence: {
    if: Proc.new { |a| a.election.halloped? && a.faculty_id.blank? },
    message: 'Either faculty or department is required.'
  }

  scope :by_election, -> (id) {
    where(election_id: id)
      .reorder(:numbering_order)
  }

end
