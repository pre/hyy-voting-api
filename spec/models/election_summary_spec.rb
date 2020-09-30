require 'rails_helper'

RSpec.describe ElectionSummary, type: :model do
  context 'when voting has not started' do
    before do
      election = FactoryBot.create :election
      blank_coalition = FactoryBot.create :coalition, election: election
      blank_alliance = FactoryBot.create :alliance,
                                          election: election,
                                          coalition: blank_coalition
      FactoryBot.create :candidate, :blank,
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
      # keep these uneven to get decimals
      @blank_votes = 6
      @actual_votes = 11
      @voter_count = 19

      election = FactoryBot.create :election
      blank_coalition = FactoryBot.create :coalition, election: election
      blank_alliance = FactoryBot.create :alliance,
                                          election: election,
                                          coalition: blank_coalition

      FactoryBot.create :candidate, :blank, :with_votes,
                         alliance: blank_alliance,
                         vote_count: @blank_votes

      coalition = FactoryBot.create :coalition, election: election

      alliance = FactoryBot.create :alliance,
                                    election: election,
                                    coalition: coalition

      FactoryBot.create :candidate, :with_votes,
                         alliance: alliance,
                         vote_count: @actual_votes

      @voter_count.times do
        FactoryBot.create :voting_right, election: election
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

    it 'returns rounded voting_percentage which includes blank votes' do
      vote_count = @actual_votes + @blank_votes
      rounded_percentage = (100.0 * vote_count / @voter_count).round 2

      expect(@summary.voting_percentage).to eq rounded_percentage
    end

  end

end
