module Vaalit
  module Entities

    class Department < Grape::Entity
      expose :name
      expose :code
    end

  end
end
