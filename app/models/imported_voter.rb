class ImportedVoter
  include ExtendedPoroBehaviour

  attr_accessor :email,
                :name,
                :ssn,
                :student_number,
                :faculty_code,
                :department_code,
                :phone,
                :extent_of_studies,
                :start_year

  def self.build_from(voter_source)
    imported = new

    imported.convert(voter_source)

    imported
  end

  def convert(voter)
    raise "Subclass must implement convert"
  end

end
