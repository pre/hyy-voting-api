module Vaalit
  module Edari

    class EdariApi < Grape::API

      before do
        @current_user = current_voter_user headers

        error!({ message: 'Unauthorized' }, :unauthorized) unless @current_user

        begin
          authorize! :access, :elections
        rescue CanCan::AccessDenied => exception
          Rails.logger.info "Unauthorized. Voting active: #{RuntimeConfig.voting_active?}; Sign in active: #{RuntimeConfig.vote_signin_active?};"
          error!({ message: "Unauthorized: #{exception.message}" }, :unauthorized)
        end

      end

      mount Vaalit::Elections
    end

  end
end
