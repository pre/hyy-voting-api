module Haka
  class VoterUser
    attr_reader :voter,
                :student_number

    def initialize(raw_student_number)
      @student_number = parse_student_number raw_student_number

      @voter = find_voter student_number
    end

    protected

    def find_voter(student_number)
      Voter.find_by_student_number! student_number
    end

    # Parse actual student id from HY format:
    # urn:schac:personalUniqueCode:fi:yliopisto.fi:x873421 => 873421
    def parse_student_number(raw)
      raw.split(":").last.delete('^0-9')
    end

  end
end
