desc 'Drop & recreate database with seed data'

namespace :db do
  task :runts => :environment do
    Rake::Task['db:drop'].invoke()
    Rake::Task['db:create'].invoke()
    Rake::Task['db:schema:load'].invoke()
    Rake::Task['db:seed:base'].invoke()
    Rake::Task['db:seed'].invoke()
  end
end
