module Vaalit
  module Entities

    class MutableVote < Grape::Entity
      expose :id
      expose :candidate_id
      expose :election_id
      expose :updated_at
    end

  end
end
