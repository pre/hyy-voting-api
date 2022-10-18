module Haka

  # Describes the person entity who is signing in from the Haka federation.
  class Person
    include ExtendedPoroBehaviour

    attr_reader :voter

    # Params:
    # - saml_student_number: URN attribute of the Haka entity's student number,
    #   may be a string with a single value or an array with multiple values.
    def initialize(saml_student_number)
      student_number = parse_student_number(saml_student_number)

      @voter = find_voter student_number
    end

    def valid?
      validate()
    end

    protected

    def validate
      @errors.blank? && voter.present?
    end

    def find_voter(student_number)
      Voter.find_by_student_number! student_number
    rescue ActiveRecord::RecordNotFound
      errors.add :voter, "no voting right for student number '#{student_number}'"
      nil
    end

    # Parse actual student id from University of Helsinki's format:
    #   urn:mace:terena.org:schac:personalUniqueCode:int:studentID:helsinki.fi:165934
    #
    # Returns the number value of the last URN attribute:
    #   raw "urn:schac:personalUniqueCode:fi:yliopisto.fi:x8734"
    #   will return: "x8734"
    #
    # Student number may be a multivalue array such as
    #   "urn:oid:1.3.6.1.4.1.25178.1.2.14"=>
    #     ["urn:schac:personalUniqueCode:int:esi:FI:1.2.246.562.24.987654321",
    #     "urn:schac:personalUniqueCode:int:studentID:helsinki.fi:01234567"]
    #   }
    # in which case the value of Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY is used.
    def parse_student_number(raw)
      if raw.blank?
        errors.add :student_number, "SAML student number value missing"
        return nil
      end

      value = nil

      if raw.is_a?(Array)
        value = parse_student_number_from_array(raw)
      elsif raw.is_a?(String)
        value = parse_student_number_from_string(raw)
      else
        raise ArgumentError, "Student number must be given either as String or String[] to preserve the leading zero."
      end

      if value.blank?
        errors.add :student_number, "SAML student number could not be found"
        return nil
      end

      value.split(":").last
    end

    def parse_student_number_from_string(str)
      return str if str.starts_with?(Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY)

      Rails.logger.info <<-MSG.squish
        Login failed because student number not found with key
        #{Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY}
      MSG
      Rails.logger.debug "Failed student number value: #{str}"

      nil
    end

    def parse_student_number_from_array(arr)
      arr.each do |v|
        return v if v.starts_with?(Vaalit::Haka::HAKA_STUDENT_NUMBER_KEY)
      end

      nil
    end
  end
end
