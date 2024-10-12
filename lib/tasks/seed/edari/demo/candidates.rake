require './lib/support/imported_csv_candidate'

namespace :db do
  namespace :seed do
    namespace :edari do
      namespace :demo do

        desc 'demo candidates from 2009 elections (requires alliances)'
        task :candidates => :environment do
          puts "Seeding candidates ..."

          filename = "./lib/support/data/2009_candidates.csv"

          puts "BEGIN: Database has now #{Candidate.count} candidates."

          separator = ","
          encoding = "UTF-8"
          count = 0

          CSV.foreach(filename,
                        col_sep: separator,
                        encoding: encoding,
                        headers: true) do |csv_candidate|

            count = count + 1
            Support::ImportedCsvCandidate.create_from! csv_candidate
          end

          puts "Imported #{count} candidates"
          puts "END: Database has now #{Candidate.count} candidates."
        end

      end
    end
  end
end
