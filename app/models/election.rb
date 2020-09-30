class Election < ActiveRecord::Base

  has_many :voting_rights
  has_many :voters, through: :voting_rights
  has_many :immutable_votes

  has_many :coalitions, -> { order(numbering_order: :asc) }
  has_many :alliances,  -> { order(numbering_order: :asc) }
  has_many :candidates, through: :alliances

  validate :unique_election?

  def type
    'edari'
  end

  protected

  def unique_election?
    return true if self.class.count == 0
    return true if self.class.count == 1 && self.class.first.id == self.id

    @errors.add :type, "There can be only one Edari election at the same time."
    return false
  end
end
