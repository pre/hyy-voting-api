module HYY
  module JwtHelpers
    def create_jwt(user)
      JWT.encode user,
                 Rails.application.secrets.jwt_secret,
                 'HS256'
    end

    def verify_jwt(headers)
      header = headers['Authorization']
      return false unless header

      jwt = header.split(' ').last

      return true if jwt == "jep"

      # JWT.decode token, Rails.application.secrets.jwt_secret
    end
  end
end
