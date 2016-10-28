class ImportedCsvVoter < ImportedVoter

  # Assumes there's no header
  # data is:
  # ssn;student_number;name;faculty;department;start_year;extent_of_studies;email;phone
  #   0    1            2    3       4          5            6                 7   8
  def convert(data)
    @ssn               = data[0]
    @student_number    = data[1]
    @name              = data[2]
    @faculty_code      = data[3]
    @department_code   = data[4]
    @start_year        = data[5]
    @extent_of_studies = data[6]
    @email             = data[7]
    @phone             = data[8]
  end

end
