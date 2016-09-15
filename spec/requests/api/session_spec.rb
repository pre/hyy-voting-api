require 'rails_helper'

describe Vaalit::Session do

  context 'POST /api/sessions' do

    it 'requires a parameter' do
      post '/api/sessions'

      expect(response).not_to be_success
      expect(json["error"]).to eq "token is missing"
    end

    it 'raises exception with invalid token' do
      post "/api/sessions?token=INVALID_TOKEN"

      expect(response).not_to be_success
      expect(json["error"]).to eq "Invalid sign-in token"
    end

    it 'requires a valid user in the token' do
      token = JsonWebToken.encode({email: "inexistant.user@example.com"},
                                  Rails.application.secrets.jwt_voter_secret)

      post "/api/sessions?token=#{token}"

      expect(response).not_to be_success
      expect(json["error"]).to eq "Invalid sign-in token"
    end

    it 'returns a session token according to the sign in token' do
      email = "user@example.com"
      voter_id = 123
      voter = FactoryGirl.build :voter, id: voter_id, email: email
      allow(Voter).to receive(:find).once.and_return(voter)

      token = JsonWebToken.encode({voter_id: voter_id},
                                  Rails.application.secrets.jwt_voter_secret)

      post "/api/sessions?token=#{token}"

      expect(response).to be_success
      expect(json["user"]["voter_id"]).to eq voter_id
      expect(json["user"]["email"]).to eq email
    end
  end
end
