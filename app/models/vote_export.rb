class VoteExport

  def self.to_csv
    votes = ImmutableVote.by_candidate

    csv = "ehdokasnumero,ääniä,vaaliliitto,ehdokasnimi\n"

    votes.each do |v|
      csv << "#{v.candidate_number},#{v.vote_count},#{v.alliance_id},#{v.candidate_name}\n"
    end

    csv
  end

end
