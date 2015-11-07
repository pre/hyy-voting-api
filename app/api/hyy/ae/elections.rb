module HYY

  module AE::Entities
    class Candidate < Grape::Entity
      expose :id
      expose :alliance_id
      expose :firstname
      expose :lastname
      expose :spare_firstname
      expose :spare_lastname
      expose :name
      expose :candidate_number, :as => :number

      private
      def name
        "#{object.firstname} #{object.lastname} (#{object.spare_firstname} #{object.spare_lastname})"
      end
    end
  end

  module AE::Entities
    class Alliance < Grape::Entity
      expose :id
      expose :name
      expose :faculty_id
      expose :department_id
      expose :candidates, using: AE::Entities::Candidate
    end
  end

  module AE::Entities
    class Election < Grape::Entity
      expose :id
      expose :type
      expose :name
      expose :faculty_id
      expose :department_id

      expose :alliances, using: AE::Entities::Alliance
      expose :candidates, using: AE::Entities::Candidate
    end
  end

  class AE::Elections < Grape::API

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
                    with: HYY::AE::Entities::Vote
          end
        end

        namespace :alliances do
          desc 'Get alliances for an election'
          get do
            present Alliance.by_election(params[:election_id]),
                    with: HYY::AE::Entities::Alliance
          end
        end

        namespace :candidates do
          desc 'Get all candidates for an election'
          get do
            present Election.find(params[:election_id]).candidates,
                    with: HYY::AE::Entities::Candidate
          end

          route_param :candidate_id do
            desc 'Cast a vote for a candidate or update previous vote (idempotent action)'
            post :vote do
              if cannot? :access, :votes
                error!({ message: 'Voting has ended' }, :unauthorized)
              end

              vote = Vote.update_or_create_by voter_id: @current_user.id,
                                              election_id: params[:election_id],
                                              candidate_id: params[:candidate_id]

              if vote.valid?
                present vote,
                        with: HYY::AE::Entities::Vote
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
