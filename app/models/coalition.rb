class Coalition < ApplicationRecord
  has_many :alliances, -> { order(numbering_order: :asc) }
  has_many :candidates, through: :alliances

  belongs_to :election

  validates_presence_of :name,
                        :short_name

  scope :by_election_with_alliances_and_candidates, ->(id) {
    where(election_id: id)
      .includes(alliances: [:candidates])
      .reorder('candidates.candidate_number ASC')
  }
end
