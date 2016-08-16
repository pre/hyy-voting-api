class Voter < ActiveRecord::Base
  has_many :votes
  has_many :faculty_elections, through: :faculty, source: :elections
  has_many :department_elections, through: :department, source: :elections

  belongs_to :faculty
  belongs_to :department

  validates_presence_of :name,
                        :ssn,
                        :faculty,
                        :department

  validates_uniqueness_of :ssn
  validates_uniqueness_of :student_number, allow_nil: true

  validates_uniqueness_of :email, allow_nil: true

  validates_length_of :name, :minimum => 4
  validates_length_of :ssn, :minimum => 6
  validates_length_of :student_number, :minimum => 4, allow_nil: true

  def self.create_from!(imported_voter)
    create!(
        :ssn               => imported_voter.ssn,
        :student_number    => imported_voter.student_number,
        :name              => imported_voter.name,
        :email             => imported_voter.email,
        :phone             => imported_voter.phone,
        :faculty           => Faculty.find_by_code!(imported_voter.faculty_code),
        :department        => Department.find_by_code!(imported_voter.department_code)
    )
  end

  # In-case-sensitive search
  def self.find_by_email(email)
    return nil if email.blank?

    where("lower(email) = ?", email.downcase).first
  end

  # In-case-sensitive search
  def self.find_by_email!(email)
    voter = find_by_email(email)

    if voter.nil?
      raise ActiveRecord::RecordNotFound.new "Couldn't find Voter by email '#{email}' (incasesensitive)"
    end

    voter
  end

  # List of elections which current user can access
  def elections
    if Vaalit::Config::IS_EDARI_ELECTION
      [Election.first]
    else
      # This is a plain array. An SQL union would require a Gem since
      # ActiveRecord does not support combining scopes with OR by default.
      faculty_elections + department_elections
    end
  end

end
