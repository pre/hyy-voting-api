require 'rails_helper'
require 'csv'

RSpec.describe ImportedCsvVoter2022, type: :model do
  describe "Creation" do

    before(:all) do
      sep = ";"
      data  = '1234567-1234;87654321;Lastname;Firstname Second;firstname1.lastname1@helsinki.fi;TTDK;H10;Teologinen tiedekunta;1.8.2020;1.8.2020;Teologian ja uskonnontutkimuksen kandiohjelma ja maisteriohjelma (3v + 2v);Teologian ja uskonnontutkimuksen kandiohjelma;180.0000000000000000'
      data2 = '7654321-4321;87654002;Lastname2;Firstname2 Second2;firstname2.lastname2@helsinki.fi;OIKTDK;H20;Oikeustieteellinen tiedekunta;1.8.2022;1.8.2022;Oikeustieteen koulutus (3v + 2v);Oikeusnotaarin koulutusohjelma;180.0000000000000000'
      data3 = '7654321-3000;87654002;Lastname2;Firstname2 Second2;;OIKTDK;H20;Oikeustieteellinen tiedekunta;;;Oikeustieteen koulutus (3v + 2v);Oikeusnotaarin koulutusohjelma;'

      @rows = []

      CSV.parse(data, col_sep: sep) do |row|
        @rows << row
      end

      CSV.parse(data2, col_sep: sep) do |row|
        @rows << row
      end

      CSV.parse(data3, col_sep: sep) do |row|
        @rows << row
      end
    end

    it "builds from csv" do
      imported_voter = ImportedCsvVoter2022.build_from(@rows.first)

      expect(imported_voter.email).to eq("firstname1.lastname1@helsinki.fi")
      expect(imported_voter.name).to eq("Lastname, Firstname Second")
      expect(imported_voter.ssn).to eq("1234567-1234")
      expect(imported_voter.student_number).to eq("87654321")
      expect(imported_voter.faculty_code).to eq("H10")
      expect(imported_voter.department_code).to eq("KH10_001")
      expect(imported_voter.phone).to eq(nil)
      expect(imported_voter.start_year).to eq 2020
      expect(imported_voter.extent_of_studies).to eq 180
    end

    it "builds from csv 2" do
      imported_voter = ImportedCsvVoter2022.build_from(@rows.second)

      expect(imported_voter.email).to eq("firstname2.lastname2@helsinki.fi")
      expect(imported_voter.name).to eq("Lastname2, Firstname2 Second2")
      expect(imported_voter.ssn).to eq("7654321-4321")
      expect(imported_voter.student_number).to eq("87654002")
      expect(imported_voter.faculty_code).to eq("H20")
      expect(imported_voter.department_code).to eq("KH20_001")
      expect(imported_voter.phone).to eq(nil)
      expect(imported_voter.start_year).to eq 2022
      expect(imported_voter.extent_of_studies).to eq 180
    end

    it "sets sane default values when source value is blank" do
      imported_voter = ImportedCsvVoter2022.build_from(@rows.third)

      expect(imported_voter.ssn).to eq("7654321-3000")
      expect(imported_voter.email).to be_nil
      expect(imported_voter.start_year).to be_nil
      expect(imported_voter.extent_of_studies).to be_nil
    end
  end
end
