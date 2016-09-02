module Vaalit
  module Voters
    class VotersApi < Grape::API

      before do
        @current_user = current_service_user headers

        error!({ message: 'Unauthorized' }, :unauthorized) unless @current_user

        begin
          authorize! :access, :voters
        rescue CanCan::AccessDenied => exception
          Rails.logger.info "Unauthorized: voter_api; voting active: #{RuntimeConfig.voting_active?}"
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
          end

          namespace :voters do
            desc 'Create a new voter'
            post do
              { jep: "toimii" }
            end
          end
        end
      end
    end
  end
end
