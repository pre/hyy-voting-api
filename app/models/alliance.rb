class Alliance < ActiveRecord::Base
  belongs_to :coalition
  belongs_to :election

  has_many :candidates, -> { order(candidate_number: :asc) }

  validates_presence_of :election_id,
                        :name,
                        :short_name

  validates_uniqueness_of :short_name,
                          :name

  validates_length_of :short_name, :in => 2..6

  scope :by_election, -> (id) {
    where(election_id: id)
      .reorder(:numbering_order)
  }

end
