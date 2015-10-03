class API < Grape::API
  prefix 'api'
  format :json
  helpers HYY::JwtHelpers

  mount HYY::Session

  mount HYY::AE
end
