class Coalition < ApplicationRecord
  has_many :alliances, -> { order(numbering_order: :asc) }
  has_many :candidates, through: :alliances

  belongs_to :election

  validates_presence_of :name,
                        :short_name

  scope :by_election, -> (id) {
    where(election_id: id)
      .reorder(:numbering_order)
  }
end
