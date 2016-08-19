
namespace :db do
  namespace :seed do
    namespace :edari do

      desc 'seed voting rights'
      task :voting_rights => :environment do
        raise "Expected exactly one Election to be present" unless Election.count == 1
        election = Election.first

        Voter.all.each do |v|
          v.create_voting_right! election: election
        end
      end

    end
  end
end
