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

        Rails.logger.info "SEED COMPLETED SUCCESFULLY"
        Rails.logger.info "Database has now:"
        Rails.logger.info "- #{Election.first.name}"
        Rails.logger.info "- #{Coalition.count} coalitions INCLUDING blank coalition"
        Rails.logger.info "- #{Alliance.count} alliances INCLUDING blank alliance"
        Rails.logger.info "- #{Candidate.count} candidates INCLUDING blank candidate (candidate_number 1)"
        Rails.logger.info "\n\nVoters and voting rights were NOT seeded, use db:seed:edari:voters_and_voting_rights"
      end
    end


  end
end
