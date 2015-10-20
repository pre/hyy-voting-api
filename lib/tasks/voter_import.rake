namespace :voters do

  desc 'Import voters from given file in Opiskelijarekisteri format'
  task :import, [:filename] => :environment do
    unless filename=ENV['filename']
      puts "Missing parameter: filename=import_file.txt"
      exit 1
    end

    CONTAINER_NAME="ROW"

    puts "BEGIN: Database has now #{Voter.count} voters."

    doc = File.open(filename) { |f| Nokogiri::XML(f) }

    count = 0

    ActiveRecord::Base.transaction do
      begin
        doc.xpath("//#{CONTAINER_NAME}").each do |xml_voter|
          count = count + 1

          imported_voter = ImportedVoter.build_from xml_voter
          puts "Number #{count} - #{imported_voter.name}"

          Voter.create_from! imported_voter
        end

        puts "Imported #{count} voters from file."

      rescue Exception => e
        puts "Error: #{e}"
        raise ActiveRecord::Rollback
      end

    end # transaction

    puts "END: Database has now #{Voter.count} voters."
  end
end
