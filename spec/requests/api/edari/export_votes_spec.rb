require 'rails_helper'
require "cancan/matchers"

describe Vaalit::Export::Votes do

  before do
    allow_any_instance_of(Vaalit::JwtHelpers)
      .to receive(:current_service_user) { ServiceUser.new }

    allow(RuntimeConfig).to receive(:elections_active?).and_return(false)

    @election = FactoryBot.create :election, :edari_election
    coalition = FactoryBot.create :coalition,
                                   election: @election
    alliance = FactoryBot.create :alliance,
                                   coalition: coalition,
                                   election: @election,
                                   name: "Hieno Allianssi"

    @candidate1 = FactoryBot.create :candidate, :with_votes,
                                      alliance: alliance,
                                      vote_count: 10,
                                      candidate_name: "Testi Eka"
    @candidate2 = FactoryBot.create :candidate, :with_votes,
                                      alliance: alliance,
                                      vote_count: 20,
                                      candidate_name: "Testi Toka"
    @candidate3 = FactoryBot.create :candidate, :with_votes,
                                      alliance: alliance,
                                      vote_count: 30,
                                      candidate_name: "Testi Kolmas"
    @blank_candidate = FactoryBot.create :candidate, :blank, :with_votes,
                                      alliance: alliance,
                                      vote_count: 25
  end

  context 'votes without blank candidate' do
    it 'returns votes in csv' do
      expect_any_instance_of(Vaalit::JwtHelpers)
        .to receive(:current_service_user)

      get "/api/export/elections/#{@election.id}/votes"

      expect(response).to be_successful

      alliance_id = @candidate1.alliance_id

      csv_string = <<-EOCSV
ehdokasnumero,ehdokasnimi,ääniä,vaaliliitto,vaaliliiton id
#{@candidate1.candidate_number},Testi Eka,10,Hieno Allianssi,#{alliance_id}
#{@candidate2.candidate_number},Testi Toka,20,Hieno Allianssi,#{alliance_id}
#{@candidate3.candidate_number},Testi Kolmas,30,Hieno Allianssi,#{alliance_id}
EOCSV

      expect(response.body).to eq csv_string
      expect(ImmutableVote.count).to eq 25 + 10 + 20 + 30
    end
  end
end
