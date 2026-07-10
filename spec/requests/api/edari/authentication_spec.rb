require 'rails_helper'

describe Vaalit::Edari::EdariApi do

  context 'with a valid JWT for a deleted voter' do
    before do
      voter = FactoryBot.create :voter
      token = JsonWebToken.encode({ voter_id: voter.id, typ: 'session' },
                                  Vaalit::Config::JWT_VOTER_SECRET)
      voter.destroy!

      get "/api/elections/1/candidates",
          headers: { "Authorization": "Bearer #{token}" }
    end

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(json["message"]).to eq "Unauthorized"
    end
  end

  context 'with a sign-in JWT used as a Bearer token' do
    before do
      voter = FactoryBot.create :voter
      token = SessionToken.new(voter).ephemeral_jwt

      get "/api/elections/1/candidates",
          headers: { "Authorization": "Bearer #{token}" }
    end

    it 'returns unauthorized' do
      expect(response).to have_http_status(:unauthorized)
      expect(json["message"]).to eq "Unauthorized"
    end
  end

  context 'with a session JWT issued by SessionToken' do
    before do
      allow(RuntimeConfig).to receive(:voting_active?).and_return(true)

      voter = FactoryBot.create :voter
      token = SessionToken.new(voter).jwt

      get "/api/elections/1/candidates",
          headers: { "Authorization": "Bearer #{token}" }
    end

    it 'passes authentication' do
      # 404 for the nonexistent election proves the request got past
      # both the typ check and the ability check.
      expect(response).to have_http_status(:not_found)
    end
  end
end
