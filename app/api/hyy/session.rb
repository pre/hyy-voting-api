module HYY

  module Entities
    class Token < Grape::Entity
      expose :jwt
      expose :elections, using: HYY::AE::Entities::Election
    end
  end

  class Session < Grape::API

    namespace :sessions do

      params do
        requires :token, type: String, desc: 'JWT token from session link'
      end
      desc 'Grant a JWT by verifying a sign-in link'
      post do
        token = Token.new URI.decode(params[:token])

        if token.valid?
          present token, with: Entities::Token
        else
          error!("Invalid sign-in token", :forbidden)
        end
      end

      params do
        requires :email, type: String, desc: 'Email where the sign-in link will be sent'
      end
      desc 'Send a sign-in link for the voter.'
      post :link do
        session_link = SessionLink.new email: params[:email]

        if session_link.valid? && session_link.deliver
          { response: "Link has been sent" }
        else
          error!("Could not generate sign-in link: #{session_link.errors[:email]}", :unprocessable_entity)
        end
      end

    end

  end
end
