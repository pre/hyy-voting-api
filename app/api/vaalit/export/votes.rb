module Vaalit
  module Export
    class Votes < Grape::API

      namespace :export do

        namespace :elections do
          params do
            requires :election_id, type: Integer
          end

          route_param :election_id do
            before do
              @election = Election.find params[:election_id]
              @summary  = ElectionSummary.new @election
            end

            namespace :summary do
              desc 'GET metadata of current election'
              get do
                {
                  votes_given:        @summary.votes_given,
                  votes_accepted:     @summary.votes_accepted,
                  voter_count:        @summary.voter_count,
                  voting_percentage:  @summary.voting_percentage,
                  candidate_count:    @summary.candidate_count
                }
              end
            end

            namespace :votes do
              format :txt

              desc 'GET votes of current election'
              get do
                ImmutableVoteExport.new(@election).to_csv
              end
            end
          end
        end
      end
    end
  end
end
