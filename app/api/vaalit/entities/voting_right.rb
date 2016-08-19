module Vaalit
  module Entities

    class VotingRight < Grape::Entity
      expose :used
      expose :voter_id
      expose :election_id
      expose :updated_at
    end

  end
end
