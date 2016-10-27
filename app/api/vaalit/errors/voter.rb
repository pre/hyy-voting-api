module Vaalit
  module Errors

    class Voter < Grape::Entity
      expose :errors
      expose :message
    end

  end
end
