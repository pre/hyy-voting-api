require 'rails_helper'

RSpec.describe Election, type: :model do
  context "halloped" do

    it "can be a faculty election" do
      election = FactoryGirl.build :election, :faculty_election

      expect(election.type).to eq "faculty"
      expect(election.halloped?).to be true
      expect(election.edari?).to be false
    end

    it "can be a department election" do
      election = FactoryGirl.build :election, :department_election

      expect(election.type).to eq "department"
      expect(election.halloped?).to be true
      expect(election.edari?).to be false
    end

    it "cannot be both department and faculty election" do
      election = FactoryGirl.build :election
      election.department = FactoryGirl.create :department
      election.faculty = FactoryGirl.create :faculty

      expect(election).not_to be_valid
      expect(election.halloped?).to be true
      expect(election.edari?).to be false
      expect(election.errors[:type]).not_to be_blank
    end
  end

end
