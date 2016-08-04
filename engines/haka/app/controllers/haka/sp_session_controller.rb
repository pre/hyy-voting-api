require_dependency "haka/application_controller"

# Service Provider
module Haka
  class SpSessionController < ApplicationController
    def new
      redirect_to "http://IDP.URL.HERE"
    end

    def consume
      redirect_to "http://SUCCESS.URL.HERE"
    end

    def ping
      render plain: "pong"
    end
  end
end
