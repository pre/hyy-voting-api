namespace :db do
  namespace :seed do
    namespace :edari do
      desc 'display summary of coalitions, alliances and candidates'
      task :summary => :environment do
        puts ""
        puts "Database has now:"
        puts "- #{Election.first.name}"
        puts "- #{Coalition.count} coalitions INCLUDING blank coalition"
        puts "- #{Alliance.count} alliances INCLUDING blank alliance"
        puts "- #{Candidate.count} candidates INCLUDING blank candidate (candidate_number 1)"
        puts ""
        puts "Voters and voting rights were NOT seeded, use db:seed:edari:voters_and_voting_rights:csv"
        puts ""
        puts "NOTE: On Heroku, use 'heroku run --no-tty task < voters.csv'"
      end
    end
  end
end
