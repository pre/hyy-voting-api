module Support
  class ImportedCsvImmutableVote
    attr_accessor :candidate_number,
                  :candidate_name,
                  :alliance_id,
                  :vote_count


    def self.create_from!(source, election_id:, created_at:)
      imported = build_from source

      imported.vote_count.times do |n|
        ImmutableVote.create!(
          candidate:   Candidate.find_by_candidate_number!(imported.candidate_number),
          election_id: election_id,
          created_at:  created_at
        )
      end
    end

    def self.build_from(source)
      new.tap { |imported| imported.convert(source) }
    end

    # Data is:
    # ehdokkaan numero, liiton numero, ehdokasnimi, äänet
    #       0              1                2         3
    def convert(data)
      @candidate_number = data[0].strip.to_i
      @alliance_id      = data[1].strip.to_i
      @candidate_name   = data[2].strip
      @vote_count       = data[3].strip.to_i
    end
  end
end
