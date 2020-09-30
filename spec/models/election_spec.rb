require 'rails_helper'

RSpec.describe Election, type: :model do
  context "halloped" do

    it "can be a faculty election" do
      election = FactoryBot.create :election, :faculty_election

      expect(election.type).to eq "faculty"
      expect(election.halloped?).to be true
      expect(election.edari?).to be false
    end

    it "can be a department election" do
      election = FactoryBot.create :election, :department_election

      expect(election.type).to eq "department"
      expect(election.halloped?).to be true
      expect(election.edari?).to be false
    end

    it "cannot be both department and faculty election" do
      election = FactoryBot.build :election
      election.department = FactoryBot.create :department
      election.faculty = FactoryBot.create :faculty

      expect(election).not_to be_valid
      expect(election.halloped?).to be true
      expect(election.edari?).to be false
      expect(election.errors[:type]).not_to be_blank
    end
  end

  context "edari" do
    it "recognizes edari type" do
      election = FactoryBot.build :election, :edari_election
      expect(election.type).to eq "edari"
      expect(election.halloped?).to be false
      expect(election.edari?).to be true
    end

    context "when building" do
      it "allows the first election" do
        expect(Election.count).to eq 0
        election = FactoryBot.build :election, :edari_election

        expect(election).to be_valid
        expect(Election.count).to eq 0

        expect(election.save).to be true
        expect(Election.count).to eq 1
      end

      it "denies the second election" do
        election = FactoryBot.build :election, :edari_election
        another_election = FactoryBot.build :election, :edari_election

        expect(election.save).to be true

        expect(another_election.save).to be false
        expect(another_election).not_to be_valid
        expect(another_election.errors[:type]).not_to be_blank
        expect(another_election.errors[:type].first)
          .to eq "There can be only one Edari election at the same time."
      end
    end

    context "when creating" do
      it "allows the first election" do
        expect(Election.count).to eq 0
        election = FactoryBot.create :election, :edari_election

        expect(election).to be_valid
        expect(Election.count).to eq 1
      end

      it "denies the second election" do
        election = FactoryBot.create :election, :edari_election

        expect(election).to be_valid

        expect {
          FactoryBot.create :election, :edari_election
        }.to raise_error ActiveRecord::RecordInvalid
      end

    end
  end

end
