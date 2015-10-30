module HYY

  module AE::Entities
    class Vote < Grape::Entity
      expose :id
      expose :candidate_id
      expose :election_id
    end
  end


  class AE::Votes < Grape::API
    desc 'Return votes of current user.'
    get :votes do
      present @current_user.votes,
              with: HYY::AE::Entities::Vote
    end
  end

end
