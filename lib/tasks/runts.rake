desc 'Drop & recreate database with seed data'

namespace :db do
  task :runts => :environment do
    Rake::Task['db:drop'].invoke()
    Rake::Task['db:create'].invoke()
    Rake::Task['db:schema:load'].invoke()
    Rake::Task['db:seed:common'].invoke()
    Rake::Task['db:seed'].invoke()

    puts "Database has been re-created with common seed data."
    puts "Next: Seed Edari (rake db:seed:edari:demo) or Halloped (rake db:seed:halloped)."
  end
end
