# Import Student Data from HY Opiskelijarekisteri
#
# Format:
#
# 200583080H012617061Aaltio Poro J J               20122     H60   firstname.lastname@helsinki.fi
#
# NOTE:
# - First character begins at 0 in Ruby
# - First character starts at 1 in Oracle format
class ImportedTextVoter < ImportedVoter

  # Character positions in Oracle format, starting 1 as the first char is:
  #
  #   010288123A013074751Lanttu Aappa E A              20052     H50   firstname.lastname@helsinki.fi
  #
  #   htunnus                   position(1:10) char,
  #   onumero                   position(11:19) char,
  #   nimi                      position(20:49) char,
  #   aloitusv                  position(50:53) char,
  #   okattav                   position(54:55) char,
  #   tiedek                    position(60:62) char,
  #   email                     position(66:120) char
  #
  # NOTE: BEWARE OF OFF-BY-ONE ERRORS! Ruby starts at 0 but Oracle starts at 1.
  #
  def convert(data)
    raise ArgumentError.new("Cannot build from empty data.") if data.blank?

    @name              = parse_name(data)
    @ssn               = parse_ssn(data)
    @student_number    = parse_student_number(data)
    @start_year        = parse_start_year(data)
    @extent_of_studies = parse_extent_of_studies(data)
    @department_code   = parse_department_code(data)
    @email             = parse_email(data)
  end

  private

  def parse_name(data)
    data[19..48].strip
  end

  # N.B. Opiskelijarekisterin hetussa ei tule väliviivaa mukana
  def parse_ssn(data)
    birthdate = data[0..5].strip
    separator = get_separator(birthdate)
    suffix = data[6..9]

    birthdate + separator + suffix
  end

  # NOTE: Vuoden 2016 Opiskelijarekisterin datassa ei huomioitu
  #       2000-luvulla syntyneitä lainkaan. Tilanne voi muuttua myöhemmin.
  def get_separator(birthdate)
    "-"
  end

  def parse_student_number(data)
    data[10..18].strip
  end

  def parse_start_year(data)
    data[49..52].strip
  end

  # Includes H in the code, eg "H50". Previously only the number was used.
  def parse_department_code(data)
    data[59..61].strip
  end

  def parse_extent_of_studies(data)
    data[53..54].strip
  end

  def parse_email(data)
    data[65..119]
  end

end
