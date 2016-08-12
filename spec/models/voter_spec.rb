require 'rails_helper'

require 'spec_helper'

RSpec.describe Voter, type: :model do

  describe "edari elections" do

    it "returns a single Election" do
      voter = FactoryGirl.build(:voter)
      election = FactoryGirl.create :election, :edari_election
      allow(Election).to receive(:first).and_return(election)
      stub_const("Vaalit::Config::IS_EDARI_ELECTION", true)

      expect(voter.elections.size).to eq 1
      expect(voter.elections.first).to eq election
    end
  end

  describe "Halloped elections" do

    it "returns a list of elections" do
      faculty_election = FactoryGirl.create :election, :faculty_election
      another_faculty_election = FactoryGirl.create :election,
                                                    :faculty_election,
                                                    faculty: faculty_election.faculty

      not_our_faculty_election = FactoryGirl.create :election, :faculty_election

      department_election = FactoryGirl.create :election, :department_election
      not_our_department_election = FactoryGirl.create :election, :department_election
      another_department_election = FactoryGirl.create :election,
                                                      :department_election,
                                                      department: department_election.department


      voter = FactoryGirl.build :voter,
                                faculty: faculty_election.faculty,
                                department: department_election.department


      stub_const("Vaalit::Config::IS_EDARI_ELECTION", false)

      expect(voter.elections.size).to eq 4
      expect(voter.elections.include? faculty_election).to be true
      expect(voter.elections.include? another_faculty_election).to be true
      expect(voter.elections.include? not_our_faculty_election).to be false

      expect(voter.elections.include? department_election).to be true
      expect(voter.elections.include? another_department_election).to be true
      expect(voter.elections.include? not_our_department_election).to be false
    end

  end

  describe "from an Imported Voter (any type)" do

    before(:each) do
      faculty_code = "H523"
      department_code = "H50"

      @imported = ImportedVoter.new(
          :name              => "Purhonen Pekka J P",
          :email             => "pekka.purhonen@example.com",
          :ssn               => "010283-1234",
          :student_number    => "0123456789",
          :phone             => "0500 123123",
          :faculty_code      => faculty_code,
          :department_code   => department_code
      )

      faculty = FactoryGirl.build(:faculty, :code => faculty_code)
      department = FactoryGirl.build(:department, :code => department_code)

      allow(Faculty).to receive(:find_by_code!) { faculty }
      allow(Department).to receive(:find_by_code!) { department }
    end

    it "creates a Voter" do
      voter = Voter.create_from! @imported

      expect(voter.email).to eq("pekka.purhonen@example.com")
      expect(voter.name).to eq("Purhonen Pekka J P")
      expect(voter.ssn).to eq("010283-1234")
      expect(voter.student_number).to eq("0123456789")
      expect(voter.faculty.code).to eq("H523")
      expect(voter.department.code).to eq("H50")
      expect(voter.phone).to eq("0500 123123")
    end
  end
end
