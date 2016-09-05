require 'csv'

class ImmutableVoteExport

  def initialize(election)
    @election = election
  end

  # Format output in rails console using `puts`
  def to_csv
    candidates_with_votes = ImmutableVote.by_candidate(@election)
    candidates_without_votes = @election.candidates.without_votes.without_blank_candidate

    csv_string = CSV.generate do |csv|
      csv << ["ehdokasnumero", "ehdokasnimi", "ääniä", "vaaliliitto", "vaaliliiton id"]

      candidates_with_votes.each do |c|
        csv << [
          c.candidate_number,
          c.candidate_name,
          c.vote_count,
          c.alliance_name,
          c.alliance_id
        ]
      end

      candidates_without_votes.each do |c|
        csv << [
          c.candidate_number,
          c.candidate_name,
          0,
          c.alliance.name,
          c.alliance_id
        ]
      end
    end

    csv_string
  end

end
