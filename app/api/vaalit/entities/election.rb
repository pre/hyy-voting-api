module Vaalit
  module Entities

    class Election < Grape::Entity
      expose :id
      expose :type
      expose :name
      expose :faculty_id
      expose :department_id
    end

  end
end
