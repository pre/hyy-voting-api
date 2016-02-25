class Election < ActiveRecord::Base
  has_many :votes

  has_many :alliances, -> { order(numbering_order: :asc) }

  has_many :candidates, through: :alliances

  belongs_to :faculty
  belongs_to :department

  # TODO: validate that both faculty && department can't be present
  def type
    if faculty_id.present?
      "faculty"
    else department_id.present?
      "department"
    end
  end
end
