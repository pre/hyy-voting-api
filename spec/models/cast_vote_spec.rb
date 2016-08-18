require 'rails_helper'

RSpec.describe CastVote, type: :model do
  context "in edari" do
    before do
      stub_const("Vaalit::Config::IS_EDARI_ELECTION", true)

      @election = FactoryGirl.create :election, :edari_election
      @voter = FactoryGirl.create :voter
      @coalition = FactoryGirl.create :coalition, election: @election
      @alliance = FactoryGirl.create :alliance, coalition: @coalition, election: @election
      @candidate = FactoryGirl.create :candidate, alliance: @alliance

      @voting_right = FactoryGirl.create :voting_right,
                                         election: @election,
                                         voter: @voter
    end

    context "when voter has a right to vote" do

      it "marks voting right as used" do
        expect(@voter.voting_right).not_to be_used

        CastVote.submit election: @election,
                        voter: @voter,
                        candidate: @candidate

        expect(@voter.voting_right).to be_used
        expect(VotingRight.find(@voting_right.id)).to be_used
      end

      it "creates a new Vote" do
        expect(@election.immutable_votes.count).to eq 0
        expect(ImmutableVote.count).to eq 0

        CastVote.submit election: @election,
                                       voter: @voter,
                                       candidate: @candidate

        expect(@election.immutable_votes.count).to eq 1
        expect(ImmutableVote.count).to eq 1

        actual_vote = @election.immutable_votes.first
        expect(actual_vote.candidate_id).to eq @candidate.id
        expect(actual_vote.election_id).to eq @election.id
      end

      it "returns true when it succeeds" do
        return_value = CastVote.submit election: @election,
                                       voter: @voter,
                                       candidate: @candidate

        expect(return_value).to be true
      end
    end

    context "when voting right has already been used" do

      it "returns false when voting right has already been used" do
        expect(@voting_right).not_to be_used
        expect(@candidate.votes.count).to eq 0
        expect(ImmutableVote.count).to eq 0

        first_try = CastVote.submit election: @election,
                                voter: @voter,
                                candidate: @candidate
        expect(first_try).to be true
        expect(@voting_right).to be_used
        expect(@candidate.votes.count).to eq 1
        expect(ImmutableVote.count).to eq 1

        duplicate = CastVote.submit election: @election,
                                    voter: @voter,
                                    candidate: @candidate

        expect(duplicate).to be false
        expect(@candidate.votes.count).to eq 1
        expect(ImmutableVote.count).to eq 1
      end
    end

    context "when updating voting right fails" do

      it "rollbacks transaction and returns false" do
        allow(@voter.voting_right).to receive(:update!).and_raise(ActiveRecord::ActiveRecordError)

        expect(@voting_right).not_to be_used
        expect(@candidate.votes.count).to eq 0

        failed_update = CastVote.submit election: @election,
                                voter: @voter,
                                candidate: @candidate

        expect(failed_update).to be_falsey

        @voting_right.reload
        expect(@voter.voting_right).not_to be_used
        expect(@voting_right).not_to be_used
        expect(VotingRight.find(@voting_right.id)).not_to be_used

        @candidate.reload
        expect(@candidate.votes.count).to eq 0
        expect(ImmutableVote.count).to eq 0
      end

    end

    context "when creating vote fails" do

      it "rollbacks transaction and returns false" do
        allow(ImmutableVote).to receive(:create!).and_raise(ActiveRecord::ActiveRecordError)

        expect(@voting_right).not_to be_used
        expect(@candidate.votes.count).to eq 0

        failed_update = CastVote.submit election: @election,
                                        voter: @voter,
                                        candidate: @candidate

        expect(failed_update).to be_falsey

        @voting_right.reload
        expect(@voter.voting_right).not_to be_used
        expect(@voting_right).not_to be_used
        expect(VotingRight.find(@voting_right.id)).not_to be_used

        @candidate.reload
        expect(@candidate.votes.count).to eq 0
        expect(ImmutableVote.count).to eq 0
      end

      it "rollbacks on a generic RuntimeError" do
        allow(ImmutableVote).to receive(:create!).and_raise(RuntimeError)

        failed_update = CastVote.submit election: @election,
                                        voter: @voter,
                                        candidate: @candidate

        expect(failed_update).to be_falsey
      end

    end

  end
end
