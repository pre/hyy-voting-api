module Vaalit
  module Entities

    class AllianceWithCandidates < Entities::Alliance
      expose :candidates, using: Entities::Candidate
    end

  end
end
