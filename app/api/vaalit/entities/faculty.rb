module Vaalit
  module Entities

    class Faculty < Grape::Entity
      expose :name
      expose :code
    end

  end
end
