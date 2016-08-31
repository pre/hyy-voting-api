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
            end

            namespace :summary do
              desc 'GET metadata of current election'
              get do
                blank_candidate = @election
                                  .candidates
                                  .find_by_candidate_number!(Vaalit::Config::BLANK_CANDIDATE_NUMBER)

                blank_votes       = blank_candidate.votes.count
                votes_given       = @election.immutable_votes.count
                voter_count       = @election.voters.count
                votes_accepted    = votes_given - blank_votes
                voting_percentage = 100.0 * votes_accepted / voter_count
                candidate_count   = @election.candidates.without_blank_candidate.count

                {
                  votes_given:        votes_given,
                  votes_accepted:     votes_accepted,
                  voter_count:        voter_count,
                  voting_percentage:  voting_percentage,
                  candidate_count:    candidate_count
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
