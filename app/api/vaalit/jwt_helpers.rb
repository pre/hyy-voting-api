module Vaalit
  module JwtHelpers

    # Find current Voter by decoding JWT from Authorization HTTP header.
    def current_voter_user(headers)
      decoded_token = decode_jwt(headers, Rails.application.secrets.jwt_voter_secret)

      if decoded_token
        Voter.find decoded_token["voter_id"]
      else
        Rails.logger.debug "Couldn't verify voter_id from jwt token (voter_id doesn't exist or token has expired)"
        return false
      end
    end

    # Find current ServiceUser by decoding JWT from Authorization HTTP header.
    def current_service_user(headers)
      if decode_jwt(headers, Rails.application.secrets.jwt_service_user_secret)
        ServiceUser.new
      else
        Rails.logger.error "Couldn't accept token for ServiceUser (token might have expired)"
        return false
      end
    end

    private
    begin

      # Decode JWT from Authorization HTTP header.
      #
      # HTTP Header is in format
      #   Authorization: "Bearer JWT_TOKEN"
      def decode_jwt(headers, secret)
        return nil unless headers['Authorization'].present?

        header = headers['Authorization']
        return nil unless header

        jwt = header.split(' ').last

        token = JsonWebToken.decode jwt, secret
        return nil unless token.present?

        # Token is in array [payload, header]
        token[0]
      end

    end
  end
end
