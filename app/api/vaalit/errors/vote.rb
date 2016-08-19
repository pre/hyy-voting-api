module Vaalit
  module Errors

    class Vote < Grape::Entity
      expose :message
      expose :voting_right, with: Entities::VotingRight
    end

  end
end
