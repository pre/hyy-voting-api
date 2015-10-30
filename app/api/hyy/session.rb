module HYY

  module Entities
    class Token < Grape::Entity
      expose :jwt
      expose :elections, using: HYY::AE::Entities::Election
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
