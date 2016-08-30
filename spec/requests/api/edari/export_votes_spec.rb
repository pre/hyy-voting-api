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

  context 'get /api/export/elections/:id/votes' do
    it 'returns votes in csv' do
      get "/api/export/elections/#{@election.id}/votes"

      expect(response).to be_success

      csv_string = <<-EOCSV
ehdokasnumero,ehdokasnimi,ääniä,vaaliliitto,vaaliliiton id
1,Testi Candidate 1,10,Alliance 1,1
2,Testi Candidate 2,20,Alliance 1,1
3,Testi Candidate 3,30,Alliance 1,1
EOCSV

      expect(response.body).to eq csv_string
    end
  end
end
