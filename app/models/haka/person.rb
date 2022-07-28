module Haka

  # Describes the person entity who is signing in from the Haka federation.
  class Person
    include ExtendedPoroBehaviour

    attr_reader :voter

    # Params:
    # - raw_student_number: URN attribute of the Haka entity's student number
    def initialize(raw_student_number)
      student_number = parse_student_number raw_student_number

      @voter = find_voter student_number
    end

    def valid?
      validate()
    end

    protected
    begin
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
      def parse_student_number(raw)
        if raw.nil?
          errors.add :student_number, "invalid value for unparsed student number: '#{raw}'"
          return
        end

        # Return a string to preserve a possible leading zero (eg "012345")
        raw.split(":").last
      end
    end
  end
end
