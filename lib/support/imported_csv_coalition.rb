module Support
  class ImportedCsvCoalition

    attr_accessor :name,
                  :numbering_order,
                  :short_name,
                  :alliance_count


    def self.create_from!(source, election_id:)
      imported = build_from source

      Coalition.create!(
        name:             imported.name,
        numbering_order:  imported.numbering_order,
        short_name:       imported.short_name,
        election_id:      election_id
      )
    rescue Exception => e
      Rails.logger.error "Failed import with #{imported.inspect}"
      raise e
    end

    def self.build_from(source)
      new.tap { |imported| imported.convert(source) }
    end

    # Assumes no header
    # Data:
    # name,numbering_order,short_name,alliance_count
    #  0     1                2              3
    def convert(data)
      @name            = data[0]
      @numbering_order = data[1]
      @short_name      = data[2]
      @alliance_count  = data[3]
    end

  end
end
