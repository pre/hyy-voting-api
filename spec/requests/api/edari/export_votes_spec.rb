require 'rails_helper'
require "cancan/matchers"

describe Vaalit::Export::Votes do

  before do
    allow_any_instance_of(Vaalit::JwtHelpers)
      .to receive(:current_service_user) { ServiceUser.new }

    allow(RuntimeConfig).to receive(:voting_active?).and_return(false)

    @election = FactoryGirl.create :election, :edari_election
    coalition = FactoryGirl.create :coalition,
                                   election: @election
    alliance = FactoryGirl.create :alliance,
                                   coalition: coalition,
                                   election: @election

    @blank_candidate = FactoryGirl.create :candidate, :blank, :with_votes,
                                      alliance: alliance,
                                      vote_count: 25
    @candidate1 = FactoryGirl.create :candidate, :with_votes,
                                      alliance: alliance,
                                      vote_count: 10
    @candidate2 = FactoryGirl.create :candidate, :with_votes,
                                      alliance: alliance,
                                      vote_count: 20
    @candidate3 = FactoryGirl.create :candidate, :with_votes,
                                      alliance: alliance,
                                      vote_count: 30
  end

  context 'votes without blank candidate' do
    it 'returns votes in csv' do
      get "/api/export/elections/#{@election.id}/votes"

      expect(response).to be_success

      csv_string = <<-EOCSV
ehdokasnumero,ehdokasnimi,ääniä,vaaliliitto,vaaliliiton id
2,Testi Candidate 2,10,Alliance 1,1
3,Testi Candidate 3,20,Alliance 1,1
4,Testi Candidate 4,30,Alliance 1,1
EOCSV

      expect(response.body).to eq csv_string
      expect(ImmutableVote.count).to eq 25 + 10 + 20 + 30
    end
  end
end
