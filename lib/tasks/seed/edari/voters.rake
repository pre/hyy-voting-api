require 'csv'

namespace :db do
  namespace :seed do
    namespace :edari do

      namespace :voters_and_voting_rights do
        desc 'seed voters from stdin in csv format'
        task :csv => :environment do
          ActiveRecord::Base.transaction do
            begin

              separator = ";"
              encoding = "UTF-8"
              count_before = Voter.count
              count = 0
              election = Election.first

              Rails.logger.info "SEEDING VOTERS"
              puts ""
              puts "==================== VOTERS ======================="
              puts ""
              puts "Database has already #{count_before} voters."
              puts ""
              puts "Paste Voters in CSV format, finally press ^D"
              puts "Expected format is (without header):"
              puts "ssn;student_number;name;faculty;department;start_year;extent_of_studies;email;phone"
              puts ""

              lines = $stdin.readlines

              lines.each do |csv_row|
                count = count + 1
                puts "csv: #{csv_row}"

                CSV.parse(csv_row, col_sep: separator, encoding: encoding) do |csv_voter|
                  imported_voter = ImportedCsvVoter.build_from csv_voter
                  Rails.logger.info "Number #{count} - #{imported_voter.faculty_code} - #{imported_voter.department_code} - #{imported_voter.student_number} - #{imported_voter.name} - #{imported_voter.email}"

                  voter = Voter.create_from! imported_voter
                  voter.create_voting_right! election: election
                end
              end

              Rails.logger.info "Database had #{count_before} voters before."
              Rails.logger.info "Imported #{count} voters from STDIN."
              Rails.logger.info "Database has now "
              Rails.logger.info "- #{Voter.count} voters."
              Rails.logger.info "- #{VotingRight.count} voting rights."
            end
          end
        end

      end

      # TODO: move this under :voters_and_voting_rights
      namespace :voters do
        desc 'seed text voters from stdin in text format and UTF-8 encoding'
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

              # Encoding cannot be converted over the 'heroku' command.
              # Source data must already be in UTF8.
              lines.each do |utf8_row|
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
