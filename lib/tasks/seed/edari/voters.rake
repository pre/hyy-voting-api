namespace :db do
  namespace :seed do
    namespace :edari do

      namespace :voters do

        desc 'seed voters from stdin in csv format'
        task :csv => :environment do
          ActiveRecord::Base.transaction do
            begin

              if Voter.count != 0
                raise "Expected Voter table to be empty (has #{Voter.count} voters)."
              end

              separator = ","
              encoding = "UTF-8"
              count = 0

              Rails.logger.info "SEEDING VOTERS"
              puts ""
              puts "==================== VOTERS ======================="
              puts "Paste Voters in CSV format, finally press ^D"
              puts "Expected format is (without header):"
              puts "ssn,student_number,name,faculty,department,email,phone"
              puts ""

              lines = $stdin.readlines

              lines.each do |csv_row|
                count = count + 1
                puts "csv: #{csv_row}"

                CSV.parse(csv_row, col_sep: separator, encoding: encoding) do |csv_voter|
                  imported_voter = ImportedCsvVoter.build_from csv_voter
                  Rails.logger.info "Number #{count} - #{imported_voter.faculty_code} - #{imported_voter.department_code} - #{imported_voter.student_number} - #{imported_voter.name} - #{imported_voter.email}"

                  Voter.create_from! imported_voter
                end
              end

              Rails.logger.info "Imported #{count} voters from STDIN."
              Rails.logger.info "Database has now #{Voter.count} voters."

            end
          end
        end

        desc 'seed text voters from stdin in text format and ISO-8859-1 encoding'
        task :text => :environment do
          ActiveRecord::Base.transaction do
            begin

              if Voter.count != 0
                raise "Expected Voter table to be empty (has #{Voter.count} voters)."
              end

              count = 0

              Rails.logger.info "SEEDING VOTERS"
              puts ""
              puts "==================== VOTERS ======================="
              puts "Paste Voters in TEXT format, finally press ^D"
              puts "Expected format is (having 1 as the first char position):"
              puts "   htunnus                   position(1:10)   char"
              puts "   onumero                   position(11:19)  char"
              puts "   nimi                      position(20:49)  char"
              puts "   aloitusv                  position(50:53)  char"
              puts "   okattav                   position(54:55)  char"
              puts "   tiedek                    position(61:62)  char"
              puts "   email                     position(66:120) char"
              puts ""

              lines = $stdin.readlines

              lines.each do |isolatin_row|
                utf8_row = isolatin_row.encode("UTF-8", "ISO-8859-1")
                puts utf8_row

                count = count + 1

                imported_voter = ImportedTextVoter.build_from utf8_row
                Rails.logger.info "Number #{count} - #{imported_voter.faculty_code} - #{imported_voter.department_code} - #{imported_voter.student_number} - #{imported_voter.name} - #{imported_voter.email}"

                Voter.create_from! imported_voter
              end

              Rails.logger.info "Imported #{count} voters from STDIN."
              Rails.logger.info "Database has now #{Voter.count} voters."

            end
          end
        end

      end
    end
  end
end
