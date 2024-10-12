
namespace :db do
  namespace :seed do
    namespace :edari do
      desc 'seed election'
      task :election => :environment do
        e = Election.create! name: "Edustajistovaalit / Delegationsval / Representative Council Elections #{Time.now.year}"
        puts "Created election: #{e.name}"
      end
    end
  end
end
