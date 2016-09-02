module Vaalit
  module Public
    class VotingPercentage < Grape::API

      namespace :public do

        namespace :elections do
          params do
            requires :election_id, type: Integer
          end

          route_param :election_id do
            before do
              @election = Election.find params[:election_id]
              @summary  = ElectionSummary.new @election
            end

            namespace :voting_percentage do
              # Rounding is needed so that nobody can determine from the
              # percentage if any one person has just voted or not.
              # (HYY Keskusvaalilautakunta 1.9.2016)
              desc 'GET voting percentage rounded to one decimal.'
              get do
                {
                  voting_percentage: @summary.voting_percentage.round(1),
                  voter_count:       @summary.voter_count,
                  has_votes:         @summary.votes_given > 0
                }
              end
            end

          end
        end
      end
    end
  end
end
