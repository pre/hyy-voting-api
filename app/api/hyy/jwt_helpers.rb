module HYY
  module JwtHelpers

    # TODO: Add token expiry
    def create_jwt(user)
      JWT.encode user,
                 Rails.application.secrets.jwt_secret,
                 'HS256'
    end

    def decode_jwt(headers)
      header = headers['Authorization']
      return nil unless header

      jwt = header.split(' ').last

      begin
        token = JWT.decode jwt, Rails.application.secrets.jwt_secret
      rescue JWT::DecodeError
        return nil
      end

      # Token is in array [payload, header]
      token[0]
    end

    def get_current_user(headers)
      decoded_token = decode_jwt(headers)

      if decoded_token
        Voter.find decoded_token["voter_id"]
      else
        Rails.logger.debug "Couldn't verify voter_id from jwt token (voter_id doesn't exist or token has expired)"
        return false
      end
    end
  end
end
