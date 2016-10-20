require 'rails_helper'

RSpec.describe ImportedTextVoter, type: :model do

  describe "text voter from student registry" do
    before(:each) do
      data = "010288123A013074751Lanttu Aappa E A              20052     H50   lanttu.aappa-inari@helsinki.fi"
      @imported = ImportedTextVoter.build_from data
    end

    it 'parses name' do
      expect(@imported.name).to eq "Lanttu Aappa E A"
    end

    # Dump data doesn't include separator
    it 'parses ssn' do
      expect(@imported.ssn).to eq "010288-123A"
    end

    it 'parses student number' do
      expect(@imported.student_number).to eq "013074751"
    end

    it 'parses start year' do
      expect(@imported.start_year).to eq "2005"
    end

    it 'parses extent_of_studies' do
      expect(@imported.extent_of_studies).to eq "2"
    end

    it 'parses department_code' do
      expect(@imported.department_code).to eq "H50"
    end

    it 'parses email' do
      expect(@imported.email).to eq "lanttu.aappa-inari@helsinki.fi"
    end

  end

  describe "Empty voter" do

    it 'fails with empty data' do
      expect(
        -> { ImportedTextVoter.build_from("") }
      ).to raise_error(ArgumentError, "Cannot build from empty data.")
    end
  end
end
