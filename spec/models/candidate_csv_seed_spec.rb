require 'rails_helper'
require './lib/support/candidate_csv_seed'

RSpec.describe CandidateCsvSeed, type: :model do
  it "converts candidate csv seed to an instance" do
    data = %Q(2,Sukunimi,Etu Nimi Monta,"Ehdokasnimi, Etu 'Lempi'",Vaaliliiton nimi)

    CSV.parse(data, col_sep: ",", encoding: "UTF-8") do |row|
      seed = CandidateCsvSeed.build_from row

      expect(seed.candidate_number).to eq 2
      expect(seed.lastname).to eq "Sukunimi"
      expect(seed.firstnames).to eq "Etu Nimi Monta"
      expect(seed.alliance_name).to eq "Vaaliliiton nimi"
      expect(seed.candidate_name).to eq "Ehdokasnimi, Etu 'Lempi'"
    end

  end
end
