class ImportedCsvVoter < ImportedVoter

  # Assumes there's no header
  # data is:
  # ssn;student_number;name;faculty;department;email;phone
  #   0    1            2    3       4          5     6
  def convert(data)
    @ssn               = data[0]
    @student_number    = data[1]
    @name              = data[2]
    @faculty_code      = data[3]
    @department_code   = data[4]
    @email             = data[5]
    @phone             = data[6]

  end

end
