require 'rails_helper'
require 'csv'

RSpec.describe ImportedCsvVoter, type: :model do
  describe "Creation" do

    before(:all) do
      sep = ";"
      data  = '010280-123A;12345678;Teppo Testaava;H40;H450;teppo.testaava@helsinki.fi;0456789100'
      data2 = '010290-123A;22345678;Seppo Sestaava;H10;H150;;;'
      @rows = []

      CSV.parse(data, col_sep: sep) do |row|
        @rows << row
      end

      CSV.parse(data2, col_sep: sep) do |row|
        @rows << row
      end

    end

    it "builds from csv" do
      puts "row: #{@rows.inspect}"
      imported_voter = ImportedCsvVoter.build_from(@rows.first)

      expect(imported_voter.email).to eq("teppo.testaava@helsinki.fi")
      expect(imported_voter.name).to eq("Teppo Testaava")
      expect(imported_voter.ssn).to eq("010280-123A")
      expect(imported_voter.student_number).to eq("12345678")
      expect(imported_voter.faculty_code).to eq("H40")
      expect(imported_voter.department_code).to eq("H450")
      expect(imported_voter.phone).to eq("0456789100")
    end


    it "sets sane default values when source value is blank" do
      imported_voter = ImportedCsvVoter.build_from(@rows[1])

      expect(imported_voter.email).to be_nil
      expect(imported_voter.phone).to be_nil
    end

  end

end
