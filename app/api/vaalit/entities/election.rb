module Vaalit
  module Entities
    class Election < Grape::Entity
      expose :id
      expose :type
      expose :name
    end
  end
end
