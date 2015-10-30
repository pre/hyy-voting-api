class Voter < ActiveRecord::Base
  has_many :votes
  has_many :faculty_elections, through: :faculty, source: :elections
  has_many :department_elections, through: :department, source: :elections

  belongs_to :faculty
  belongs_to :department

  validates_presence_of :name,
                        :ssn,
                        :student_number,
                        :faculty,
                        :department

  validates_uniqueness_of :ssn,
                          :student_number

  validates_uniqueness_of :email, allow_nil: true

  validates_length_of :name, :minimum => 4
  validates_length_of :ssn, :minimum => 6
  validates_length_of :student_number, :minimum => 6

  def self.create_from!(imported_voter)
    create!(
        :ssn               => imported_voter.ssn,
        :student_number    => imported_voter.student_number,
        :name              => imported_voter.name,
        :email             => imported_voter.email,
        :phone             => imported_voter.phone,
        :start_year        => imported_voter.start_year,
        :extent_of_studies => imported_voter.extent_of_studies,
        :faculty           => Faculty.find_by_code!(imported_voter.faculty_code),
        :department        => Department.first # TODO: Get actual departments
    )
  end

  def elections
    faculty_elections + department_elections
  end
end
