require 'rails_helper'

describe Vaalit::Public do

  before do
    @election = FactoryBot.create(:election)
  end

  context 'when voting has not started' do
    before do
      get "/api/public/elections/#{@election.id}/voting_percentage"
    end

    it 'was a successful request' do
      expect(response).to be_success
    end

    it 'returns status that there are no votes' do
      expect(json["voting_percentage"]).to eq(0)
      expect(json["has_votes"]).to eq(false)
    end
  end

  context 'when voting has started' do

    before do
      # keep these uneven to get decimals
      @actual_vote_count = 11
      @voter_count = 21

      @voter_count.times do
        FactoryBot.create :voting_right, election: @election
      end

      coalition = FactoryBot.create :coalition, election: @election

      alliance = FactoryBot.create :alliance,
                                    election: @election,
                                    coalition: coalition

      FactoryBot.create :candidate, :with_votes,
                         alliance: alliance,
                         vote_count: @actual_vote_count

      get "/api/public/elections/#{@election.id}/voting_percentage"
    end

    it 'was a successful request' do
      expect(response).to be_success
    end

    it 'returns voter count' do
      expect(json['voter_count']).to eq @voter_count
    end

    it 'returns status that there are votes' do
      expect(json["has_votes"]).to eq(true)
    end

    it 'returns status that there are votes' do
      expect(json["has_votes"]).to eq(true)
    end

    it 'returns voting percentage with one decimal' do
      percentage = (100.0 * @actual_vote_count) / @voter_count
      percentage_without_decimals = percentage.round(1)

      expect(json["voting_percentage"]).to eq(percentage_without_decimals)
    end
  end
end
