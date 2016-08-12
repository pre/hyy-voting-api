module Vaalit
  module Entities

    class Election < Grape::Entity
      expose :id
      expose :type
      expose :name
      expose :faculty_id
      expose :department_id

      expose :alliances, using: Entities::Alliance
      expose :candidates, using: Entities::Candidate
    end

  end
end
