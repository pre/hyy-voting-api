require 'rails_helper'

RSpec.describe ElectionSummary, type: :model do
  context 'when voting has not started' do
    before do
      election = FactoryGirl.create :election
      blank_coalition = FactoryGirl.create :coalition, election: election
      blank_alliance = FactoryGirl.create :alliance,
                                          election: election,
                                          coalition: blank_coalition
      FactoryGirl.create :candidate, :blank,
                         alliance: blank_alliance

      @summary = ElectionSummary.new election
    end

    it 'returns 0 votes given' do
      expect(@summary.votes_given).to eq 0
    end

    it 'returns 0 votes accepted' do
      expect(@summary.votes_accepted).to eq 0
    end

    it 'returns 0 blank votes' do
      expect(@summary.blank_votes).to eq 0
    end

    it 'returns voter count' do
      expect(@summary.voter_count).to eq 0
    end

    it 'returns candidate count' do
      expect(@summary.candidate_count).to eq 0
    end

    it 'returns 0.0 voting_percentage' do
      expect(@summary.voting_percentage).to eq 0.0
    end
  end

  context 'when election has votes' do
    before do
      @blank_votes = 5
      @actual_votes = 11
      @voter_count = 20

      election = FactoryGirl.create :election
      blank_coalition = FactoryGirl.create :coalition, election: election
      blank_alliance = FactoryGirl.create :alliance,
                                          election: election,
                                          coalition: blank_coalition

      FactoryGirl.create :candidate, :blank, :with_votes,
                         alliance: blank_alliance,
                         vote_count: @blank_votes

      coalition = FactoryGirl.create :coalition, election: election

      alliance = FactoryGirl.create :alliance,
                                    election: election,
                                    coalition: coalition

      FactoryGirl.create :candidate, :with_votes,
                         alliance: alliance,
                         vote_count: @actual_votes

      @voter_count.times do
        FactoryGirl.create :voting_right, election: election
      end

      @summary = ElectionSummary.new election
    end

    it 'returns votes given' do
      expect(@summary.votes_given).to eq @actual_votes + @blank_votes
    end

    it 'returns votes accepted' do
      expect(@summary.votes_accepted).to eq @actual_votes
    end

    it 'returns blank votes' do
      expect(@summary.blank_votes).to eq @blank_votes
    end

    it 'returns voter count' do
      expect(@summary.voter_count).to eq @voter_count
    end

    it 'returns candidate count ignoring the blank candidate' do
      expect(@summary.candidate_count).to eq 1
    end

    it 'returns voting_percentage which includes blank votes' do
      vote_count = @actual_votes + @blank_votes

      expect(@summary.voting_percentage).to eq(100.0 * vote_count / @voter_count)
    end

  end

end
