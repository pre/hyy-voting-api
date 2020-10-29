module Vaalit
  module Public
    class PublicApi < Grape::API
      mount Public::VotingPercentage
    end
  end
end
