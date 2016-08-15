
namespace :db do
  namespace :seed do
    namespace :edari do

      desc 'seed election'
      task :election => :environment do
        puts "Creating Edari elections"
        Election.create! name: "Edustajistovaalit #{Time.now.year}"
      end

    end
  end
end
