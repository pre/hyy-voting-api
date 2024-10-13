desc 'Drop & recreate database with seed data'

namespace :db do
  task :runts => :environment do
    Rake::Task['db:drop'].invoke()
    Rake::Task['db:create'].invoke()
    Rake::Task['db:schema:load'].invoke()
    Rake::Task['db:seed:common'].invoke()
    Rake::Task['db:seed'].invoke()

    puts ""
    puts "Database has been re-created with common seed data."
    puts ""
    puts "Next: "
    puts "a) Start from scratch (blank Election): rake db:seed:edari:election"
    puts "b) Seed demo data: rake db:seed:edari:demo"
    puts "c) Seed CSV Candidate data: bin/seed-edari local"
  end
end
