require 'rails_helper'
require "cancan/matchers"

describe Vaalit::Stats::StatsApi do
  describe 'authorization by cancan' do
    context 'when unauthorized' do
      let(:users) do
        [
          FactoryBot.build(:voter),
          FactoryBot.build(:guest_user),
          nil
        ]
      end

      it 'is denied by cancan' do
        users.each do |u|
          expect(Ability.new(u)).not_to be_able_to(:access, :stats)
        end
      end
    end

    context 'when service user' do
      let(:user) { ServiceUser.new }
      subject(:ability) { Ability.new(user) }

      it { should be_able_to(:access, :stats) }
    end
  end

  describe "/api/stats/votes_by_hour" do
    let(:mock_response) { '{"votes_by_hour":"ok"}' }

    before do
      allow_any_instance_of(Vaalit::JwtHelpers)
        .to receive(:current_service_user) { ServiceUser.new }
      allow(VoteStatistics)
        .to receive(:by_hour_as_json)
        .and_return(mock_response)
    end

    it 'responds successfully' do
      expect_any_instance_of(Vaalit::JwtHelpers)
        .to receive(:current_service_user)

      get '/api/stats/votes_by_hour'

      expect(response).to be_successful
      expect(response.body).to eq mock_response
    end
  end

  describe "/api/stats/votes_by_faculty" do
    let(:mock_response) { '{"votes_by_faculty":"ok"}' }

    before do
      allow_any_instance_of(Vaalit::JwtHelpers)
        .to receive(:current_service_user) { ServiceUser.new }
      allow(VoteStatistics)
        .to receive(:by_faculty_as_json)
        .and_return(mock_response)
    end

    it 'responds successfully' do
      expect_any_instance_of(Vaalit::JwtHelpers)
        .to receive(:current_service_user)

      get '/api/stats/votes_by_faculty'

      expect(response).to be_successful
      expect(response.body).to eq mock_response
    end
  end
end
