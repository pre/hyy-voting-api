module Vaalit
    module Entities

      class Coalition < Grape::Entity
        expose :id
        expose :name
        expose :short_name
      end

    end
end
