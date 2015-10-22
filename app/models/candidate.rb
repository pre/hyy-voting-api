class Candidate < ActiveRecord::Base
  include RankedModel
  ranks :numbering_order

  has_many :votes

  belongs_to :alliance

  has_one :faculty, through: :alliance
  has_one :department, through: :alliance

  validates_presence_of :alliance,
                        :firstname,
                        :lastname,
                        :spare_firstname,
                        :spare_lastname

end
