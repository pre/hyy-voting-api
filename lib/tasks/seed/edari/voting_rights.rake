
namespace :db do
  namespace :seed do
    namespace :edari do
      desc 'seed voting rights'
      task :voting_rights => :environment do
        raise "Expected exactly one Election to be present!" unless Election.count == 1
        election = Election.first

        raise "Expected no voting rights to be yet present!" unless VotingRight.count == 0

        puts "Creating voting rights .."

        Voter.all.each do |v|
          Rails.logger.info "Creating voting right for #{v.name}"
          v.create_voting_right! election: election
        end

        puts "Created #{VotingRight.count} voting rights in election #{election.name}"
      end
    end
  end
end
