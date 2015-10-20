require 'rails_helper'

RSpec.describe ImportedVoter, type: :model do
  describe "Creation" do

    it "builds from xml" do
      row = Nokogiri::XML "
        <ROW>
          <HTUNNUS>123456789A</HTUNNUS>
          <ONUMERO>987654321</ONUMERO>
          <NIMI>Riippala Laura R              </NIMI>
          <ALOITUSV>2001</ALOITUSV>
          <OKATTAV>4 </OKATTAV>
          <lisa>    </lisa>
          <TIEDEK>H30</TIEDEK>
          <HLO>1234567</HLO>
          <OPINOIK>12345678</OPINOIK>
          <SAHKPOSTOSOI>laura.riippala@example.com</SAHKPOSTOSOI>
          <MATKPUH>0500 123123</MATKPUH>
        </ROW>"

      imported_voter = ImportedVoter.build_from(row)

      expect(imported_voter.email).to eq("laura.riippala@example.com")
      expect(imported_voter.name).to eq("Riippala Laura R")
      expect(imported_voter.ssn).to eq("123456789A")
      expect(imported_voter.student_number).to eq("987654321")
      expect(imported_voter.faculty_code).to eq("H30")
      expect(imported_voter.phone).to eq("0500 123123")
      expect(imported_voter.extent_of_studies).to eq("4")
      expect(imported_voter.start_year).to eq("2001")

    end


  end
end
