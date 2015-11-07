module HYY

  module Entities
    class User < Grape::Entity
      expose :voter_id
      expose :email
    end

    class Faculty < Grape::Entity
      expose :name
      expose :code
    end

    class Department < Grape::Entity
      expose :name
      expose :code
    end

    class Voter < Grape::Entity
      expose :name
      expose :email
      expose :phone
      expose :faculty, using: Entities::Faculty
      expose :department, using: Entities::Department
    end
  end

  module Entities
    class Token < Grape::Entity
      expose :jwt
      expose :elections,
        using: HYY::AE::Entities::Election,
        if: lambda { |token, opts| RuntimeConfig.voting_active? }
      expose :voter, using: HYY::Entities::Voter
      expose :user, using: HYY::Entities::User
    end
  end

  class Session < Grape::API

    before do
      begin
        authorize! :access, :sessions
      rescue CanCan::AccessDenied => exception
        error!("Unauthorized: #{exception.message}", :unauthorized)
      end
    end

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
