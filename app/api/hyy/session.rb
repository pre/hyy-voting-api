module HYY

  module Entities
    class Election < Grape::Entity
      expose :id
      expose :type
      expose :name
      expose :faculty_id
      expose :department_id

      expose :alliances
      expose :candidates

      private
        def alliances
          {
            url: "http://localhost:3000/api/alliances?election_id=3"
          }
        end

        def candidates
          {
            url: "http://localhost:3000/api/candidates?election_id=3"
          }
        end
    end
  end

  module Entities
    class Token < Grape::Entity
      expose :jwt
      expose :elections, using: HYY::Entities::Election
    end
  end

  class Session < Grape::API

    desc 'Send a sign-in link for the voter.'
    post :token do
      { response: "Link has been sent" }
    end

    desc 'Grant a JWT by verifying a sign-in link'
    post :sessions do
      token = Token.new params[:token]

      if token.valid?
        present token, with: Entities::Token
      else
        status :forbidden
        response = { error: "invalid token" }
      end

      status :created
      response
    end
  end
end
