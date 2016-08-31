module Vaalit
  module Halloped

    # Administration Elections
    # aka. Halloped
    # aka. Hallinnon opiskelijaedustajien vaalit
    # generally just Hallintovaalit
    class HallopedApi < Grape::API

      before do
        @current_user = current_voter_user headers

        error!({ message: 'Unauthorized' }, :unauthorized) unless @current_user

        begin
          authorize! :access, :ae_namespace
        rescue CanCan::AccessDenied => exception
          error!({ message: "Unauthorized: #{exception.message}" }, :unauthorized)
        end

      end

      mount Vaalit::Halloped::Ping
      mount Vaalit::Halloped::Votes
    end

  end
end
