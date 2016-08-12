module Vaalit
  module JwtHelpers

    # Decode JWT from Authorization HTTP header and find current user.
    def get_current_user(headers)
      decoded_token = decode_jwt(headers)

      if decoded_token
        Voter.find decoded_token["voter_id"]
      else
        Rails.logger.debug "Couldn't verify voter_id from jwt token (voter_id doesn't exist or token has expired)"
        return false
      end
    end

    private
    begin

      # HTTP Header is in format
      #   Authorization: "Bearer JWT_TOKEN"
      def decode_jwt(headers)
        return nil unless headers['Authorization'].present?

        header = headers['Authorization']
        return nil unless header

        jwt = header.split(' ').last

        token = JsonWebToken.decode jwt
        return nil unless token.present?

        # Token is in array [payload, header]
        token[0]
      end

    end
  end
end
