module Vaalit
  module Entities

    class Candidate < Grape::Entity
      expose :id
      expose :alliance_id
      expose :firstname
      expose :lastname
      expose :spare_firstname
      expose :spare_lastname
      expose :name
      expose :candidate_number, :as => :number

      private

      # TODO: Move to Candidate model
      def name
        "#{object.firstname} #{object.lastname} (#{object.spare_firstname} #{object.spare_lastname})"
      end
    end

  end
end
