class Election < ActiveRecord::Base

  has_many :voting_rights
  has_many :voters, through: :voting_rights
  has_many :immutable_votes  if Vaalit::Config::IS_EDARI_ELECTION
  has_many :mutable_votes    if Vaalit::Config::IS_HALLOPED_ELECTION

  has_many :coalitions, -> { order(numbering_order: :asc) }
  has_many :alliances,  -> { order(numbering_order: :asc) }
  has_many :candidates, through: :alliances

  belongs_to :faculty
  belongs_to :department

  validate :valid_election_type?,   if: Proc.new { |e| e.halloped? }
  validate :unique_edari_election?, if: Proc.new { |e| e.edari? }

  def type
    if faculty_id.present?
      "faculty"
    elsif department_id.present?
      "department"
    else
      "edari"
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
    return true if halloped? && ( faculty.blank? || department.blank? )

    @errors.add :type, "Halloped election can only be a department OR faculty election (not both)."
    return false
  end

  def unique_edari_election?
    return true if self.class.count == 0
    return true if self.class.count == 1 && self.class.first.id == self.id

    @errors.add :type, "There can be only one Edari election at the same time."
    return false
  end
end
