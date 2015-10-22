class ImportedVoter
  include ExtendedPoroBehaviour

  attr_accessor :xml,
                :email,
                :name,
                :ssn,
                :student_number,
                :faculty_code,
                :phone,
                :extent_of_studies,
                :start_year

  def self.build_from(xml_voter)
    imported = new

    imported.convert(xml_voter)

    imported
  end

  def convert(xml_voter)
    @xml = xml_voter

    @email             = value 'SAHKPOSTOSOI'
    @name              = value 'NIMI'
    @ssn               = value 'HTUNNUS'
    @student_number    = value 'ONUMERO'
    @faculty_code      = value 'TIEDEK'
    @phone             = value 'MATKPUH'
    @extent_of_studies = value 'OKATTAV'
    @start_year        = value 'ALOITUSV'
  end

  private

  def value(path)
    value = @xml.xpath("#{path}/text()").to_s.strip

    if value.blank?
      nil
    else
      value
    end
  end
end
