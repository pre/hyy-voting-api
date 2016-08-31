class API < Grape::API
  prefix 'api'
  format :json

  helpers Vaalit::JwtHelpers

  helpers do
    include CanCan::ControllerAdditions

    # Monkey patch to use @current_user
    def current_ability
      @current_ability ||= ::Ability.new(@current_user)
    end
  end

  if Vaalit::Config::IS_HALLOPED_ELECTION
    mount Vaalit::Halloped::HallopedApi # Authorized
  end

  if Vaalit::Config::IS_EDARI_ELECTION
    mount Vaalit::Edari::EdariApi # Authorized
  end

  mount Vaalit::Export::ExportApi # Authorized

  # Shared between Edari and Halloped
  mount Vaalit::Pling   # Public
  mount Vaalit::Session # Public

end
