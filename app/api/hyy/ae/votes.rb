module HYY

  module AE::Entities
    class Vote < Grape::Entity
      expose :id
      expose :candidate_id
      expose :election_id
      expose :updated_at
    end
  end


  class AE::Votes < Grape::API
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
              with: HYY::AE::Entities::Vote
    end
  end

end
