namespace :db do
  namespace :seed do
    namespace :edari do

      desc 'DEMO election with voters, coalitions, alliances and candidates'
      task :demo => :environment do
        Rake::Task['db:seed:edari:election'].invoke()
        Rake::Task['db:seed:edari:demo:voters'].invoke()
        Rake::Task['db:seed:edari:voting_rights'].invoke()
        Rake::Task['db:seed:edari:demo:coalitions_and_alliances'].invoke()
        Rake::Task['db:seed:edari:demo:candidates'].invoke()
        Rake::Task['db:seed:edari:blank_candidate'].invoke()

        puts "To seed 2009 votes, run"
        puts "  rake db:seed:edari:demo:votes"
      end

    end
  end
end
