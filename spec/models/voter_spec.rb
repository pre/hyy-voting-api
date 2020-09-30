require 'rails_helper'

require 'spec_helper'

RSpec.describe Voter, type: :model do

  describe "edari elections" do

    it "returns a single Election" do
      voter = FactoryBot.build(:voter)
      election = FactoryBot.create :election, :edari_election
      allow(Election).to receive(:first).and_return(election)
      stub_const("Vaalit::Config::IS_EDARI_ELECTION", true)

      expect(voter.elections.size).to eq 1
      expect(voter.elections.first).to eq election
    end
  end

  describe "from an Imported Voter (any type)" do

    before(:each) do
      faculty_code = "H523"
      department_code = "H50"

      @imported = ImportedVoter.new(
          :name              => "Purhonen Pekka J P",
          :email             => "pekka.purhonen@example.com               \r\n",
          :ssn               => "010283-1234",
          :student_number    => "0123456789",
          :phone             => "0500 123123",
          :faculty_code      => faculty_code,
          :department_code   => department_code
      )

      faculty = FactoryBot.build(:faculty, :code => faculty_code)
      department = FactoryBot.build(:department, :code => department_code)

      allow(Faculty).to receive(:find_by_code) { faculty }
      allow(Department).to receive(:find_by_code) { department }
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

  describe "import errors" do
    let(:existing_faculty_code) { 'H123' }
    let(:without_faculty) do
      FactoryBot.build(:imported_voter, faculty_code: 'no_faculty')
    end

    let(:without_department) do
      FactoryBot.build(
        :imported_voter,
        department_code: 'no_department',
        faculty_code: existing_faculty_code
      )
    end

    it "displays error if Faculty is not found" do
      expect do
        Voter.create_from!(without_faculty)
      end.to raise_error "Faculty not found: no_faculty"
    end

    it "displays error if Department is not found" do
      FactoryBot.create :faculty, code: existing_faculty_code

      expect do
        Voter.create_from!(without_department)
      end.to raise_error "Department not found: no_department"
    end
  end
end
