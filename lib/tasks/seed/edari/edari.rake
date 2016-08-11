namespace :db do
  namespace :seed do

    desc 'Edari election (coalitions, alliances and candidates)'
    task :edari => :environment do
      Rake::Task['db:seed:edari:coalitions_and_alliances'].invoke()
      Rake::Task['db:seed:edari:candidates'].invoke()
    end

  end
end
