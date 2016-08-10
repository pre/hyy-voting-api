# List routes:
#   rake routes
#   rake grape:routes
#
Rails.application.routes.draw do

  # Grape API in app/api/
  mount API => '/'

  # SAML Authentication from the Haka federation
  namespace :haka do
    get 'auth/new'
    get 'auth/consume'
    post 'auth/consume'
  end

end
