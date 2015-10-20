class ImportedVoter

  attr_accessor :email,
                :name,
                :ssn,
                :student_number,
                :faculty_code,
                :phone,
                :extent_of_studies,
                :start_year

  def self.build_from(xml_voter)
    imported = new

    imported.init_from xml_voter

    imported
  end

  def init_from(xml_voter)
    @email = xml_voter.xpath('//ROW/SAHKPOSTOSOI/text()').to_s.strip
    @name = xml_voter.xpath('//ROW/NIMI/text()').to_s.strip
    @ssn = xml_voter.xpath('//ROW/HTUNNUS/text()').to_s.strip
    @student_number = xml_voter.xpath('//ROW/ONUMERO/text()').to_s.strip
    @faculty_code = xml_voter.xpath('//ROW/TIEDEK/text()').to_s.strip
    @phone = xml_voter.xpath('//ROW/MATKPUH/text()').to_s.strip
    @extent_of_studies = xml_voter.xpath('//ROW/OKATTAV/text()').to_s.strip
    @start_year = xml_voter.xpath('//ROW/ALOITUSV/text()').to_s.strip
  end
end
