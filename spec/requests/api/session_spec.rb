require 'rails_helper'

describe HYY::Session do

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
      token = JsonWebToken.encode({email: "inexistant.user@example.com"})

      post "/api/sessions?token=#{token}"

      expect(response).not_to be_success
      expect(json["error"]).to eq "Invalid sign-in token"
    end

    it 'returns a session token according to the sign in token' do
      email = "user@example.com"
      voter = FactoryGirl.build :voter, email: email
      allow(Voter).to receive(:find_by_email!).and_return(voter)
      token = JsonWebToken.encode({email: email})

      post "/api/sessions?token=#{token}"

      expect(response).to be_success
      expect(json["user"]["email"]).to eq email
    end
  end
end
