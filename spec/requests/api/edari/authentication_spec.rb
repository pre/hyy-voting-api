require 'rails_helper'

describe Vaalit::Edari::EdariApi do

  context 'with a valid JWT for a deleted voter' do
    before do
      voter = FactoryBot.create :voter
      token = JsonWebToken.encode({ voter_id: voter.id },
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
end
