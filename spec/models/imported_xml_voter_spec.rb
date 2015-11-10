require 'rails_helper'

RSpec.describe ImportedXmlVoter, type: :model do
  describe "Creation" do

    before(:all) do
      xml_text = '
      <?xml version="1.0" encoding="utf-8" ?>
      <ROWDATA>
        <ROW>
          <hetu>123456789A</hetu>
          <opiskelijanro>987654321</opiskelijanro>
          <nimi>Riippala Laura R              </nimi>
          <tiedekunta>H30</tiedekunta>
          <laitos>H523</laitos>
          <s_posti>laura.riippala@example.com</s_posti>
          <puhelin>0500 123123</puhelin>
        </ROW>

        <ROW>
          <hetu>987654321B</hetu>
          <opiskelijanro>987654321</opiskelijanro>
          <nimi>Toinen Kaura P</nimi>
          <tiedekunta>H40</tiedekunta>
          <laitos>H432</laitos>
          <s_posti></s_posti>
          <puhelin>0400121212</puhelin>
        </ROW>
      </ROWDATA>
      '

      @doc = Nokogiri::XML(xml_text)
    end

    it "builds from xml" do

      xml_voter = @doc.xpath("//ROW").first

      imported_voter = ImportedXmlVoter.build_from(xml_voter)

      expect(imported_voter.email).to eq("laura.riippala@example.com")
      expect(imported_voter.name).to eq("Riippala Laura R")
      expect(imported_voter.ssn).to eq("123456789A")
      expect(imported_voter.student_number).to eq("987654321")
      expect(imported_voter.faculty_code).to eq("H30")
      expect(imported_voter.department_code).to eq("H523")
      expect(imported_voter.phone).to eq("0500 123123")

    end

    it "sets sane default values when source value is blank" do

      xml_voter = @doc.xpath("//ROW")[1]

      imported_voter = ImportedXmlVoter.build_from(xml_voter)

      expect(imported_voter.email).to be_nil
    end
  end
end
