require 'rails_helper'

RSpec.describe EmailTokenProcessor, type: :model do
  context "sign in from an email link" do

    before do
      @example_email = "email@example.com"
      @voter_id = 4321
      @jwt = JsonWebToken.encode({email: @example_email})

      voter = FactoryGirl.build :voter, {
        email: @example_email,
        id: @voter_id
      }

      allow(Voter).to receive(:find_by_email!).and_return(voter)
    end

    it "creates a valid session token" do
      token = EmailTokenProcessor.new @jwt

      expect(token).to be_valid
      expect(token.session_token.user.voter.email).to eq(@example_email)
      expect(token.session_token.user.voter.id).to eq(@voter_id)
    end

  end
end
