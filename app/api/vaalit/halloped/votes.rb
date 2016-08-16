module Vaalit
  module Halloped

    class Votes < Grape::API
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
                with: Vaalit::Entities::Vote
      end
    end

  end
end
