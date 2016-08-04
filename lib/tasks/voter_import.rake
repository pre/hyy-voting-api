require 'csv'

namespace :voters do

  namespace :import do

    desc 'Import voters from CSV.'
    task :csv, [:filename] => :environment do
      puts "NOTE NOTE NOTE"
      puts "MS Excel on OS X cannot export CSV files which would work with umlauts!"
      puts "The used charset is not anything standard."
      unless filename=ENV['filename']
        puts "Missing parameter: filename=import_file.txt"
        exit 1
      end

      SEPARATOR = ","
      ENCODING = "UTF-8"

      puts "BEGIN: Database has now #{Voter.count} voters."

      count = 0

      ActiveRecord::Base.transaction do
        begin
          CSV.foreach(filename, col_sep: SEPARATOR, encoding: ENCODING) do |row|
            count = count + 1

            puts "täällä: #{row.inspect}"
            imported_voter = ImportedCsvVoter.build_from row
            puts "Number #{count} - #{imported_voter.faculty_code} - #{imported_voter.department_code} - #{imported_voter.student_number} - #{imported_voter.name} - #{imported_voter.email}"

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

    desc 'Import voters from XML file'
    task :xml, [:filename] => :environment do
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

            imported_voter = ImportedXmlVoter.build_from xml_voter
            puts "Number #{count} - #{imported_voter.faculty_code} - #{imported_voter.department_code} - #{imported_voter.student_number} - #{imported_voter.name} - #{imported_voter.email}"

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

end
