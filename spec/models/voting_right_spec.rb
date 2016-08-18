require 'rails_helper'

RSpec.describe VotingRight, type: :model do
  context "edari" do

    before do
      stub_const("Vaalit::Config::IS_EDARI_ELECTION", true)

      @election = FactoryGirl.create :election, :edari_election
      @voter = FactoryGirl.create :voter
      @coalition = FactoryGirl.create :coalition, election: @election
      @alliance = FactoryGirl.create :alliance, coalition: @coalition, election: @election
      @candidate = FactoryGirl.create :candidate, alliance: @alliance
    end

    context "when VotingRight already has a matching row (voter_id,election_id)" do
      before do
        @voting_right = FactoryGirl.create :voting_right,
                                           election: @election,
                                           voter: @voter
      end

      it "fails validation" do
        expect(@voting_right).to be_valid

        duplicate = VotingRight.create election: @election,
                                       voter: @voter

        expect(duplicate).not_to be_valid
        expect(duplicate.errors[:voter].first).to eq "has already been taken"
      end

    end

  end
end
