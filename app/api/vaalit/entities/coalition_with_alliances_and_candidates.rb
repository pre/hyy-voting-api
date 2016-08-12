module Vaalit
  module Entities

    class CoalitionWithAlliancesAndCandidates < Entities::Coalition
      expose :alliances, using: Entities::AllianceWithCandidates
    end

  end
end
