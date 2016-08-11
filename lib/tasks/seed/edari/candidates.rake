require './lib/support/candidate_csv_seed'

namespace :db do
  namespace :seed do
    namespace :edari do

      desc 'candidates (requires alliances)'
      task :candidates => :environment do
        puts "Seeding candidates ..."

        SEPARATOR = ","
        ENCODING = "UTF-8"
        filename = "./lib/support/candidates_2009.csv"

        puts "BEGIN: Database has now #{Candidate.count} candidates."
        count = 0

        alliances = {}
        Alliance.all.each do |a|
          alliances[a.name] = a.id
        end

        ActiveRecord::Base.transaction do
          begin
            CSV.foreach(filename,
                        col_sep: SEPARATOR,
                        encoding: ENCODING,
                        headers: true) do |row|

              count = count + 1

              imported = CandidateCsvSeed.build_from row
              puts "Number #{count} - #{imported.candidate_name}"

              candidate = Candidate.new.tap do |c|
                c.firstname = imported.firstnames
                c.lastname = imported.lastname
                c.candidate_number = imported.candidate_number
                c.candidate_name = imported.candidate_name

                c.alliance_id = alliances[imported.alliance_name]
              end

              candidate.save!
            end

            puts "Imported #{count} candidates."

          rescue Exception => e
            puts "Error: #{e}"
            raise ActiveRecord::Rollback
          end

        end # transaction

        puts "END: Database has now #{Candidate.count} candidates."

      end

    end
  end
end
