require 'rails_helper'

RSpec.describe SignInTokenProcessor, type: :model do
  context "sign in from an existing JWT (from email link or after Haka auth)" do

    before do
      @example_email = "email@example.com"
      @voter_id = 4321
      @jwt = JsonWebToken.encode({email: @example_email},
                                 Rails.application.secrets.jwt_voter_secret)

      voter = FactoryGirl.build :voter, {
        email: @example_email,
        id: @voter_id
      }

      allow(Voter).to receive(:find).and_return(voter)
    end

    it "creates a valid session token" do
      processor = SignInTokenProcessor.new @jwt

      expect(processor).to be_valid
      expect(processor.session_token.user.voter.email).to eq(@example_email)
      expect(processor.session_token.user.voter.id).to eq(@voter_id)
    end

  end

  context "invalid source token" do
    it "will fail validations" do
      processor = SignInTokenProcessor.new "invalid_jwt"

      expect(processor).not_to be_valid
      expect(processor.errors[:source_token].first).to eq "Invalid source JWT token in the sign in link"
    end

  end
end
