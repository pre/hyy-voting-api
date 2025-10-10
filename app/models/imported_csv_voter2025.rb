class ImportedCsvVoter2025 < ImportedVoter

  # Assumes there's no header
  # 2025
  # opiskelijanro;henkilotunnus;sukunimi;etunimet;email;tdk;opintojen_aloitusvuosi;opintojen_aloituslukukausi
  #   0              1            2         3       4    5     6                       7
  #
  # Example row:
  # 012345677;010101A1111;Lastname;First Name Multiple;firstname.lastname@helsinki.fi;FTDK;2025;S
  def convert(data)
    @student_number = data[0]
    @ssn = data[1]
    @name = "#{data[2]}, #{data[3]}"
    @email = data[4]
    @faculty_abbreviation = parse_abbr(data[5])
    @start_year = data[6]
  rescue StandardError => e
    puts "Failed with #{data.inspect}"
    raise e
  end

  def parse_extent_of_studies(str)
    return nil if str.blank?

    str.to_i
  end

  # Data might contain multiple faculties, pick the first one
  def parse_abbr(faculty_str)
    return nil if faculty_str.blank?

    faculty_str.split(",").first
  end
end
