require 'rails_helper'

RSpec.describe SessionToken, type: :model do
  context "create a new token" do

    before do
      @example_email = "email@example.com"
      @voter_id = 4321

      voter = FactoryBot.build :voter, {
        email: @example_email,
        id: @voter_id
      }

      @token = SessionToken.new voter
    end

    it "raises without a voter object" do
      expect{SessionToken.new}.to raise_error(ArgumentError)
    end

    it "is valid" do
      expect(@token).to be_valid
      expect(@token.user.voter.email).to eq(@example_email)
      expect(@token.user.voter.id).to eq(@voter_id)
    end

    it "marks the session JWT with typ session" do
      payload = JsonWebToken.decode(@token.jwt, Vaalit::Config::JWT_VOTER_SECRET).first

      expect(payload["typ"]).to eq("session")
      expect(payload["voter_id"]).to eq(@voter_id)
    end

    it "marks the ephemeral JWT with typ signin" do
      payload = JsonWebToken.decode(@token.ephemeral_jwt, Vaalit::Config::JWT_VOTER_SECRET).first

      expect(payload["typ"]).to eq("signin")
      expect(payload["voter_id"]).to eq(@voter_id)
    end

  end
end
