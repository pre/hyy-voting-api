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

      params do
        requires :election_id, type: Integer
      end
      route_param :election_id do

        before do
          @election = Election.find params[:election_id]

          if cannot? :access, @election
            error!(
              { message: "User #{@current_user.id} does not have access to election #{params[:election_id]}" },
              :unauthorized)
          end
        end

        namespace :voting_right do
          desc 'Tells whether user can cast a vote in current election'
          get do
            voting_right = @current_user.voting_right

            if voting_right.present?
              present voting_right,
                      with: Entities::VotingRight
            else
              error!(
                { message: "User #{@current_user.id} does not have voting right in election #{params[:election_id]}" },
                :unauthorized)
            end
          end
        end

        namespace :vote do

            desc 'Cast a vote for a candidate' do
              failure [[422, 'Unprocessable entity', Errors::Vote]]
            end
            params do
              requires :candidate_id, type: Integer
            end
            post do
              if cannot? :access, :votes
                error!({ message: 'Voting has ended' }, :unauthorized)
              end

              result = CastVote.submit voter: @current_user,
                                       election: @election,
                                       candidate: Candidate.find(params[:candidate_id])

              if result
                present @current_user.voting_right, with: Entities::VotingRight
              else
                error!(
                  {
                    voting_right: @current_user.voting_right,
                    message: 'Vote could not be submitted'
                  }, 422)
              end
            end

        end

        namespace :coalitions do
            desc 'Get coalitions, include candidates using :with_candidates=true'
            params do
              optional :with_candidates, type: Boolean
            end
            get do
              if params[:with_candidates]
                entity = Entities::CoalitionWithAlliancesAndCandidates
              else
                entity = Entities::Coalition
              end

              present Coalition.by_election(params[:election_id]),
                      with: entity
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
        end
      end

    end
  end
end
