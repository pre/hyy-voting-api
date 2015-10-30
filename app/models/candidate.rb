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


  # If candidate numbers have been given, order by candidate numbers.
  # Otherwise order by alliance id and numbering order.
  def self.for_listing
    candidate_numbers_given? ? reorder('candidate_number') : reorder('alliance_id, numbering_order')
  end

  def self.candidate_numbers_given?
    first && where(:candidate_number => nil).empty?
  end

  def self.in_numbering_order
     self
      .select("#{table_name}.*")
      .joins(:alliance)
      .reorder(
        "alliances.numbering_order,
        candidates.numbering_order")
      .all
  end

  def self.give_numbers!
    self.transaction do
      self.update_all :candidate_number => 0

      self.in_numbering_order.each_with_index do |candidate, i|
        candidate.update_attribute :candidate_number, i+2 # skip zero and 1
      end
    end

    return true
  end
end
