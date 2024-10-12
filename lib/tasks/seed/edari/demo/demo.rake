namespace :db do
  namespace :seed do
    namespace :edari do
      desc 'DEMO election with voters, coalitions, alliances and candidates (no votes)'
      task :demo => :environment do
        puts 'Create demo data from HYY 2009 election..'
        Rake::Task['db:seed:edari:election'].invoke()

        puts 'Create example voters and voting rights..'
        Rake::Task['db:seed:edari:demo:voters'].invoke()

        puts 'Create coalitions, alliances and candidates..'
        Rake::Task['db:seed:edari:demo:coalitions_and_alliances'].invoke()
        Rake::Task['db:seed:edari:demo:candidates'].invoke()
        Rake::Task['db:seed:edari:blank_candidate'].invoke()

        puts "To seed votes of year 2009, run"
        puts "  rake db:seed:edari:demo:votes"
      end
    end
  end
end
