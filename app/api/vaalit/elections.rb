module Vaalit
  class Elections < Grape::API

    before do
      begin
        authorize! :access, :elections
      rescue CanCan::AccessDenied => exception
        error!({ message: "Unauthorized: #{exception.message}" }, :unauthorized)
      end
    end

    namespace :elections do

      route_param :election_id do

        before do
          @election = Election.find params[:election_id]

          if cannot? :access, @election
            error!(
              { message: "User #{@current_user.id} does not have access to election #{params[:election_id]}" },
              :unauthorized)
          end
        end

        namespace :vote do
          desc 'Get previously cast vote in election'
          get do
            present @current_user.votes.by_election(params[:election_id]).first,
                    with: Entities::Vote
          end
        end

        namespace :alliances do
          desc 'Get alliances for an election'
          get do
            present Alliance.by_election(params[:election_id]),
                    with: Entities::Alliance
          end
        end

        namespace :candidates do
          desc 'Get all candidates for an election'
          get do
            present Election.find(params[:election_id]).candidates,
                    with: Entities::Candidate
          end

          route_param :candidate_id do
            desc 'Cast a vote for a candidate or update a previously cast vote (idempotent action)'
            post :vote do
              if cannot? :access, :votes
                error!({ message: 'Voting has ended' }, :unauthorized)
              end

              vote = Vote.update_or_create_by voter_id: @current_user.id,
                                              election_id: params[:election_id],
                                              candidate_id: params[:candidate_id]

              if vote.valid?
                present vote, with: Entities::Vote
              else
                error!(
                  {
                    message: 'Vote failed',
                    errors: vote.errors.as_json
                  }, 422)
              end
            end

          end
        end
      end

    end
  end
end
