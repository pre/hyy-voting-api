require 'rails_helper'

RSpec.describe VotingRight, type: :model do
  context "edari" do

    before do
      @election = FactoryBot.create :election, :edari_election
      @voter = FactoryBot.create :voter
      @coalition = FactoryBot.create :coalition, election: @election
      @alliance = FactoryBot.create :alliance, coalition: @coalition, election: @election
      @candidate = FactoryBot.create :candidate, alliance: @alliance
    end

    context "when VotingRight already has a matching row (voter_id,election_id)" do
      before do
        @voting_right = FactoryBot.create :voting_right,
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
