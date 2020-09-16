class ApplicationController < ActionController::API
  if RuntimeConfig.http_basic_auth?
    include ActionController::HttpAuthentication::Basic::ControllerMethods

    http_basic_authenticate_with(
      name: Vaalit::Config::HTTP_BASIC_AUTH_USERNAME,
      password: Vaalit::Config::HTTP_BASIC_AUTH_PASSWORD
    )
  end
end
