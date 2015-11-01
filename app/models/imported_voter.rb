class ImportedVoter
  include ExtendedPoroBehaviour

  attr_accessor :xml,
                :email,
                :name,
                :ssn,
                :student_number,
                :faculty_code,
                :department_code,
                :phone

  def self.build_from(xml_voter)
    imported = new

    imported.convert(xml_voter)

    imported
  end

  def convert(xml_voter)
    @xml = xml_voter

    @email             = value 's_posti'
    @name              = value 'nimi'
    @ssn               = value 'hetu'
    @student_number    = value 'opiskelijanro'
    @faculty_code      = value 'tiedekunta'
    @department_code   = value 'laitos'
    @phone             = value 'puhelin'
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
