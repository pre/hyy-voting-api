require 'rails_helper'
require "cancan/matchers"

describe Vaalit::Elections do

  describe "POST /api/elections/:election_id/vote" do
    before do
      allow(RuntimeConfig).to receive(:voting_active?).and_return(true)

      @election = FactoryBot.create :election, :edari_election
      @coalition = FactoryBot.create :coalition, election: @election
      @alliance = FactoryBot.create :alliance,
                                    coalition: @coalition,
                                    election: @election
      @candidate = FactoryBot.create :candidate, alliance: @alliance
      @voter = FactoryBot.create :voter, :with_voting_right, election: @election

      token = JsonWebToken.encode({ voter_id: @voter.id },
                                  Vaalit::Config::JWT_VOTER_SECRET)
      @headers = { "Authorization": "Bearer #{token}" }
    end

    def cast_vote(candidate_id)
      post "/api/elections/#{@election.id}/vote",
           params: { candidate_id: candidate_id },
           headers: @headers
    end

    it 'casts the vote and marks the voting right used' do
      cast_vote @candidate.id

      expect(response).to have_http_status(:created)
      expect(json["used"]).to eq true
      expect(@voter.voting_right.reload).to be_used
      expect(ImmutableVote.count).to eq 1
    end

    it 'returns 422 with the voting right when the vote is submitted twice' do
      cast_vote @candidate.id
      cast_vote @candidate.id

      expect(response).to have_http_status(422)
      expect(json["message"]).to eq "Vote could not be submitted"
      expect(json["voting_right"]["used"]).to eq true
      expect(ImmutableVote.count).to eq 1
    end

    it 'returns 422 when the candidate belongs to another election' do
      # Election validates that only one election exists at a time,
      # so bypass validation to set up a candidate in another election.
      other_election = FactoryBot.build :election, :edari_election
      other_election.save! validate: false
      other_coalition = FactoryBot.create :coalition, election: other_election
      other_alliance = FactoryBot.create :alliance,
                                         coalition: other_coalition,
                                         election: other_election
      other_candidate = FactoryBot.create :candidate, alliance: other_alliance

      cast_vote other_candidate.id

      expect(response).to have_http_status(422)
      expect(ImmutableVote.count).to eq 0
      expect(@voter.voting_right.reload).not_to be_used
    end
  end

  describe "authorization" do
    subject(:ability) { Ability.new(user) }
    let(:user) { nil }

    context "when current user is a voter" do
      let(:user) { FactoryBot.build(:voter) }

      it { should be_able_to(:access, :elections) }
      it { should be_able_to(:access, Election) }
      it { should be_able_to(:access, :votes) }
    end

    context "when current user is a guest" do
      let(:user) { FactoryBot.build(:guest_user) }

      it { should_not be_able_to(:access, :elections) }
      it { should_not be_able_to(:access, Election) }
      it { should_not be_able_to(:access, :votes) }
    end

    context "when current user is a service user" do
      let(:user) { FactoryBot.build(:service_user) }

      it { should_not be_able_to(:access, :elections) }
      it { should_not be_able_to(:access, Election) }
      it { should_not be_able_to(:access, :votes) }
    end

    context "when current user is nil" do
      let(:user) { nil }

      it { should_not be_able_to(:access, :elections) }
      it { should_not be_able_to(:access, Election) }
      it { should_not be_able_to(:access, :votes) }
    end

    context "when current user is a voter" do
      let(:user) { FactoryBot.build(:voter) }

      context "when voting is ongoing" do
        before do
          allow(RuntimeConfig).to receive(:voting_active?).and_return(true)
        end

        it { should be_able_to(:access, :elections) }
        it { should be_able_to(:access, Election) }
        it { should be_able_to(:access, :votes) }
      end

      context "when voting is not ongoing" do
        before do
          allow(RuntimeConfig).to receive(:voting_active?).and_return(false)
          allow(RuntimeConfig).to receive(:vote_signin_active?).and_return(false)
        end

        it { should_not be_able_to(:access, :elections) }
        it { should_not be_able_to(:access, Election) }
        it { should_not be_able_to(:access, :votes) }
      end

      context "when signing in has ended but voting grace period is ongoing" do
        before do
          allow(RuntimeConfig).to receive(:voting_active?).and_return(true)
          allow(RuntimeConfig).to receive(:vote_signin_active?).and_return(false)
        end

        it { should be_able_to(:access, :elections) }
        it { should be_able_to(:access, Election) }
        it { should be_able_to(:access, :votes) }
      end
    end
  end
end
