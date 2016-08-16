module Vaalit
  module Halloped

    # Used when a Vote can be changed (Halloped elections)
    class Entities::Vote < Grape::Entity
      expose :id
      expose :candidate_id
      expose :election_id
      expose :updated_at
    end

  end
end
