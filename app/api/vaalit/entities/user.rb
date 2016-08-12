module Vaalit
  module Entities

    class User < Grape::Entity
      expose :voter_id
      expose :email
    end

  end
end
