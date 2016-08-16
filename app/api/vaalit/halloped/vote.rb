module Vaalit
  module Halloped

    class Vote < Grape::API
      before do
        begin
          authorize! :access, :elections
        rescue CanCan::AccessDenied => exception
          error!({ message: "Unauthorized: #{exception.message}" }, :unauthorized)
        end
      end

      desc 'Return votes of current user.'
      get :votes do
        present @current_user.votes,
                with: Vaalit::Entities::Halloped::Vote
      end

      # TODO: this was extracted from Halloped/Edari split-off and is untested.
      #       Halloped-specific api where user can change his vote.
      #
      # namespace :elections do
      #
      #   params do
      #     requires :election_id, type: Integer
      #   end
      #   route_param :election_id do
      #
      #     namespace :vote do
      #       desc 'Get previously cast vote in election'
      #       get do
      #         present @current_user.votes.by_election(params[:election_id]).first,
      #         with: Entities::Halloped::Vote
      #       end
      #     end
      #
      #     namespace :candidates do
      #
      #       params do
      #         requires :candidate_id, type: Integer
      #       end
      #       route_param :candidate_id do
      #         desc 'Cast a vote for a candidate or update a previously cast vote (idempotent action)'
      #         post :vote do
      #           if cannot? :access, :votes
      #             error!({ message: 'Voting has ended' }, :unauthorized)
      #           end
      #
      #           vote = Vote.update_or_create_by voter_id: @current_user.id,
      #                                           election_id: params[:election_id],
      #                                           candidate_id: params[:candidate_id]
      #
      #           if vote.valid?
      #             present vote, with: Entities::Halloped::Vote
      #           else
      #             error!(
      #               {
      #                 message: 'Vote failed',
      #                 errors: vote.errors.as_json
      #               }, 422)
      #           end
      #         end
      #       end
      #
      #     end
      #   end
      #
      # end
    end
  end
end
