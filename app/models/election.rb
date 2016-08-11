class Election < ActiveRecord::Base
  has_many :votes

  has_many :alliances, -> { order(numbering_order: :asc) }

  has_many :candidates, through: :alliances

  belongs_to :faculty
  belongs_to :department

  validate :valid_election_type?

  def type
    if faculty_id.present?
      "faculty"
    else department_id.present?
      "department"
    end
  end

  def halloped?
    ["faculty", "department"].include? type
  end

  def edari?
    not halloped?
  end

  protected

  def valid_election_type?
    return true if edari?
    return true if halloped? && ( faculty.blank? || department.blank? )

    @errors.add :type, "Halloped election can only be a department OR faculty election (not both)."
    return false
  end
end
