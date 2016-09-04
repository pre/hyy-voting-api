class Voter < ActiveRecord::Base

  has_one  :voting_right       if Vaalit::Config::IS_EDARI_ELECTION
  # TODO:Halloped
  # has_many :voting_rights      if Vaalit::Config::IS_HALLOPED_ELECTION
  # has_many :mutable_votes      if Vaalit::Config::IS_HALLOPED_ELECTION
  #
  # TODO:Halloped:
  # validates_presence_of :faculty, :department
  has_many :faculty_elections,    through: :faculty,    source: :elections
  has_many :department_elections, through: :department, source: :elections

  belongs_to :faculty
  belongs_to :department

  validates_presence_of :name,
                        :ssn

  validates_uniqueness_of :ssn
  validates_uniqueness_of :student_number, allow_nil: true

  validates_uniqueness_of :email, allow_nil: true

  validates_length_of :name,           :minimum => 4
  validates_length_of :ssn,            :minimum => 6
  validates_length_of :student_number, :minimum => 4, allow_nil: true

  validates_format_of :email,
                      :allow_nil => true,
                      :with => /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]+\z/

  scope :created_during_elections, lambda {
    where("created_at > ?", Vaalit::Config::VOTE_SIGNIN_STARTS_AT)
      .order(created_at: :desc)
  }

  def self.create_from!(voter_attrs)
    voter = new(
        ssn:               voter_attrs.ssn.strip,
        student_number:    voter_attrs.student_number.strip,
        name:              voter_attrs.name.strip,
        email:             voter_attrs.email.strip,
        phone:             voter_attrs.phone.strip
    )

    if voter_attrs.faculty_code.present?
      voter.faculty = Faculty.find_by_code! voter_attrs.faculty_code
    end

    if voter_attrs.department_code.present?
      voter.department = Department.find_by_code! voter_attrs.department_code
    end

    voter.save!

    voter
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
      # Halloped elections
      # This is a plain array. An SQL union would require a Gem since
      # ActiveRecord does not support combining scopes with OR by default.
      # TODO: use Voter#voting_rights instead
      faculty_elections + department_elections
    end
  end

end
