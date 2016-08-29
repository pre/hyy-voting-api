namespace :db do
  namespace :seed do
    namespace :edari do

      desc 'seed voters from stdin in csv format'
      task :voters => :environment do
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
    end
  end
end
