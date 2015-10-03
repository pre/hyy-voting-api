class API < Grape::API
  prefix 'api'
  format :json

  mount HYY::AE::Ping
  mount HYY::AE::Post
  mount HYY::AE::Protected
end
