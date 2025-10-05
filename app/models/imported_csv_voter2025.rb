class ImportedCsvVoter2025 < ImportedVoter

  # Assumes there's no header
  # 2025
  # student_number;ssn;lastname;firstnames;email;faculty;start_year
  #   0              1     2         3       4       5     6
  def convert(data)
    @student_number = data[0]
    @ssn = data[1]
    @name = "#{data[2]}, #{data[3]}"
    @email = data[4]
    @faculty_abbreviation = parse_abbr(data[5])
    @start_year = parse_year_from_date(data[6])
  end

  def parse_extent_of_studies(str)
    return nil if str.blank?

    str.to_i
  end

  # date: "1.8.2020"
  # return: "2020"
  def parse_year_from_date(date_str)
    return nil if date_str.blank?

    Time.parse(date_str).year
  end

  # Data might contain multiple faculties, pick the first one
  def parse_abbr(faculty_str)
    return nil if faculty_str.blank?

    faculty_str.split(",").first
  end
end
