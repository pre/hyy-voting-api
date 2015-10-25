module HYY

  module AE::Entities
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
      def name
        "#{object.firstname} #{object.lastname} (#{object.spare_firstname} #{object.spare_lastname})"
      end
    end
  end

  class AE::Candidates < Grape::API
    desc 'Get all candidates for an election'
    # TODO: Scope by election id
    get :candidates do
      present Candidate.all, with: AE::Entities::Candidate
    end
  end
end
