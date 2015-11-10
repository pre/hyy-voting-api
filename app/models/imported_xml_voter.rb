class ImportedXmlVoter < ImportedVoter

  attr_accessor :xml

  def convert(voter)
    @xml = voter

    @email             = value 's_posti'
    @name              = value 'nimi'
    @ssn               = value 'hetu'
    @student_number    = value 'opiskelijanro'
    @faculty_code      = value 'tiedekunta'
    @department_code   = value 'laitos'
    @phone             = value 'puhelin'
  end

  protected

  def value(path)
    value = @xml.xpath("#{path}/text()").to_s.strip

    if value.blank?
      nil
    else
      value
    end
  end

end
