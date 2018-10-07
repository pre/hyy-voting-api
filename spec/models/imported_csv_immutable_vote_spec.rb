require 'rails_helper'
require './lib/support/imported_csv_immutable_vote'

RSpec.describe ImportedCsvImmutableVote, type: :model do
  describe "Import" do

    before(:all) do
      sep = ","
      data = <<-EOCSV
321, 1, Mukava Maikki, 28
322, 1, Kiva Kuikka, 15
323, 1, Joku Muu, 0
EOCSV
      @rows = []

      CSV.parse(data, col_sep: sep) do |row|
        @rows << row
      end

    end

    context "build" do
      it "builds from csv" do
        imported = ImportedCsvImmutableVote.build_from(@rows.first)

        expect(imported.candidate_number).to eq(321)
        expect(imported.alliance_id).to eq(1)
        expect(imported.candidate_name).to eq("Mukava Maikki")
        expect(imported.vote_count).to eq(28)
      end
    end

    context "create" do

      before do
        @election = FactoryGirl.create :election
        coalition = FactoryGirl.create :coalition, election: @election
        alliance = FactoryGirl.create :alliance,
                            coalition: coalition,
                            election: @election,
                            name: "Akateemiset nallekarhut"

        @c_maikki = FactoryGirl.create :candidate,
                                        candidate_number: 321,
                                        alliance: alliance

        @c_kuikka = FactoryGirl.create :candidate,
                                        candidate_number: 322,
                                        alliance: alliance

        @c_jokumuu = FactoryGirl.create :candidate,
                                        candidate_number: 323,
                                        alliance: alliance

      end

      it "creates one from csv" do
        expect(ImmutableVote.count).to eq 0

        how_many = ImportedCsvImmutableVote.create_from!(
          @rows.first,
          election_id: @election.id,
          created_at: '2016-01-02'
        )

        expect(how_many).to eq 28
        expect(ImmutableVote.count).to eq 28
        expect(ImmutableVote.where(
            candidate_id: @c_maikki.id,
            election_id: @election.id
          ).count
        ).to eq 28
      end

      it "creates all from csv" do
        expect(ImmutableVote.count).to eq 0

        maikki_how_many = ImportedCsvImmutableVote.create_from!(
          @rows.first,
          election_id: @election.id,
          created_at: '2016-01-02'
        )

        expect(maikki_how_many).to eq 28
        expect(ImmutableVote.count).to eq 28
        expect(ImmutableVote.where(
            candidate_id: @c_maikki.id,
            election_id: @election.id
          ).count
        ).to eq 28

        kuikka_how_many = ImportedCsvImmutableVote.create_from!(
          @rows.second,
          election_id: @election.id,
          created_at: '2016-01-02'
        )

        expect(kuikka_how_many).to eq 15
        expect(ImmutableVote.count).to eq 28+15
        expect(ImmutableVote.where(
            candidate_id: @c_kuikka.id,
            election_id: @election.id
          ).count
        ).to eq 15

        jokumuu_how_many = ImportedCsvImmutableVote.create_from!(
          @rows.third,
          election_id: @election.id,
          created_at: '2016-01-02'
        )

        expect(jokumuu_how_many).to eq 0
        expect(ImmutableVote.count).to eq 28+15+0
        expect(ImmutableVote.where(
            candidate_id: @c_jokumuu.id,
            election_id: @election.id
          ).count
        ).to eq 0
      end
    end

  end
end
