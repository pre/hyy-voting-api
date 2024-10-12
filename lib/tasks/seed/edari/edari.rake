namespace :db do
  namespace :seed do
    desc 'election with voters, coalitions, alliances and candidates'
    task :edari => :environment do
      ActiveRecord::Base.transaction do
        begin
          Rake::Task['db:seed:edari:election'].invoke()
          Rake::Task['db:seed:edari:coalitions'].invoke()
          Rake::Task['db:seed:edari:alliances'].invoke()
          Rake::Task['db:seed:edari:candidates'].invoke()
          Rake::Task['db:seed:edari:blank_candidate'].invoke()
        rescue Exception => e
          puts "Error: #{e}"
          puts ""
          puts "Rolling back everything"
          raise ActiveRecord::Rollback
        end

        puts "SEED COMPLETED SUCCESFULLY"
        puts "=========================="

        Rake::Task['db:seed:edari:summary'].invoke()
      end
    end
  end
end
