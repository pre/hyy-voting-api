class Coalition < ApplicationRecord
  has_many :alliances
  has_many :candidates, through: :alliances

  belongs_to :election

  validates_presence_of :name,
                        :short_name

end
