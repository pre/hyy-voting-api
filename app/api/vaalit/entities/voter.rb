module Vaalit
  module Entities

    class Voter < Grape::Entity
      expose :name
      expose :email
      expose :phone
      expose :faculty, using: Entities::Faculty
      expose :department, using: Entities::Department
    end

  end
end
