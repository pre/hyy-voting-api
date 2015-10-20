require 'rails_helper'

require 'spec_helper'

RSpec.describe Voter, type: :model do
  describe "from an Imported Voter" do

    before(:each) do
      faculty_code = "H55"

      @imported = ImportedVoter.new(
          :name              => "Purhonen Pekka J P",
          :email             => "pekka.purhonen@example.com",
          :ssn               => "010283-1234",
          :student_number    => "0123456789",
          :phone             => "0500 123123",
          :extent_of_studies => 2,
          :faculty_code      => faculty_code
      )

      faculty = FactoryGirl.build(:faculty, :code => faculty_code)
      allow(Faculty).to receive(:find_by_code!) { faculty }
      # Faculty.stub!(:find_by_code).and_return faculty
    end

    it "creates a Voter" do
      voter = Voter.create_from! @imported

      expect(voter.email).to eq("pekka.purhonen@example.com")
      expect(voter.name).to eq("Purhonen Pekka J P")
      expect(voter.ssn).to eq("010283-1234")
      expect(voter.student_number).to eq("0123456789")
      expect(voter.faculty.code).to eq("H55")
      expect(voter.phone).to eq("0500 123123")
      expect(voter.extent_of_studies).to eq(2)
    end
  end
end
