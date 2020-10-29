module Vaalit
  module Stats
    class StatsApi < Grape::API
      before do
        @current_user = current_service_user headers

        error!({ message: 'Unauthorized' }, :unauthorized) unless @current_user

        begin
          authorize! :access, :stats
        rescue CanCan::AccessDenied => e
          Rails.logger.info "AccessDenied to stats_api"
          error!({ message: "Unauthorized: #{e.message}" }, :unauthorized)
        end
      end

      namespace :stats do
        namespace :votes_by_hour do
          desc 'GET vote count by hour'
          get do
            JSON.parse VoteStatistics.by_hour_as_json
          end
        end

        namespace :votes_by_faculty do
          desc 'GET vote count by faculty'
          get do
            JSON.parse VoteStatistics.by_faculty_as_json
          end
        end
      end
    end
  end
end
