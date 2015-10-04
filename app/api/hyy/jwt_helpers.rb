module HYY
  module JwtHelpers
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
  end
end
