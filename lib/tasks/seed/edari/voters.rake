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
              puts "Expected format is 2025 (without header):"
              puts "student_number;ssn;lastname;firstnames;email;faculty;start_year"
              puts ""

              lines = $stdin.readlines

              lines.each do |csv_row|
                count = count + 1
                puts "csv: #{csv_row}"

                CSV.parse(csv_row, col_sep: separator, encoding: encoding) do |csv_voter|
                  imported_voter = ImportedCsvVoter2025.build_from csv_voter
                  Rails.logger.info "Number #{count} - #{imported_voter.faculty_code} - #{imported_voter.department_code} - #{imported_voter.student_number} - #{imported_voter.name} - #{imported_voter.email}"

                  voter = Voter.create_from! imported_voter
                  voter.create_voting_right! election: election
                end
              end

              puts "Database had #{count_before} voters before."
              puts "Imported #{count} voters from STDIN."
              puts "Database has now "
              puts "- #{Voter.count} voters."
              puts "- #{VotingRight.count} voting rights."
            end
          end
        end
      end
    end
  end
end
