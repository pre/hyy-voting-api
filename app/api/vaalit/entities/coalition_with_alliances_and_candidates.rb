module Vaalit
  module Entities

    class CoalitionWithAlliancesAndCandidates < Entities::Coalition
      expose :alliances, using: Entities::AllianceWithCandidates
      expose :alliance_count

      private

      def alliance_count
        object.alliances.count
      end

    end

  end
end
