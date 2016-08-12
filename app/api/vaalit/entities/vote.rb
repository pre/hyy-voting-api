module Vaalit
  module Entities

    # Used when a Vote can be changed (Halloped elections)
    class Vote < Grape::Entity
      expose :id
      expose :candidate_id
      expose :election_id
      expose :updated_at
    end

  end
end
