class CandidateCsvSeed

  attr_accessor :candidate_number,
                :candidate_name,
                :lastname,
                :firstnames,
                :alliance_name

  def self.build_from(voter_source)
    imported = new

    imported.convert(voter_source)

    imported
  end

  # Data is:
  # NRO,sukunimi,etunimet,ehdokasnimi,liiton nimi
  # 0   1        2        3            4
  def convert(data)
    @candidate_number = data[0].to_i
    @lastname         = data[1]
    @firstnames       = data[2]
    @candidate_name   = data[3]
    @alliance_name    = data[4]
  end

end
