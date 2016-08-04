class API < Grape::API
  prefix 'api'
  format :json

  helpers HYY::JwtHelpers

  helpers do
    include CanCan::ControllerAdditions

    # Monkey patch: use @current_user
    def current_ability
      @current_ability ||= ::Ability.new(@current_user)
    end
  end

  # Public endpoints
  mount HYY::Session

  # Everything is protected under Administration Election
  mount HYY::AE

  mount Edari::Public
end
