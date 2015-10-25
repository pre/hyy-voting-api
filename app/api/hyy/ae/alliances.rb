module HYY

  module AE::Entities
    class Alliance < Grape::Entity
      expose :id
      expose :name
      expose :faculty_id
      expose :department_id
      expose :candidates, using:AE::Entities::Candidate
    end
  end

  class AE::Alliances < Grape::API
    desc 'Get alliances for election'

    params do
      requires :election_id, type: Integer, desc: "Election of the Alliance"
    end

    # TODO Verify that voter can access election_id
    get :alliances do
      present Alliance.by_election(params.election_id), with: AE::Entities::Alliance
    end
  end
end
