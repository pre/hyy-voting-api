module HYY
  class Session < Grape::API

    desc 'Send a sign-in link for the voter.'
    post :token do
      { response: "Link has been sent" }
    end

    desc 'Grant a JWT by verifying a sign-in link'
    post :sessions do
      token = Token.new params[:token]

      if token.valid?
        response = {
          jwt: create_jwt(token.user),
          details: "detailit"
        }
      else
        status :forbidden
        response = { error: "invalid token" }
      end

      status :created
      response
    end
  end
end
