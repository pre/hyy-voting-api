require 'rails_helper'

module Haka
  RSpec.describe SpSessionController, type: :controller do
    routes { Haka::Engine.routes }

    describe "GET new" do

      it "gets new" do
        get :new

        expect(response).to be_redirect
        expect(response).to redirect_to(Haka::Config::SAML_IDP_SSO_TARGET_URL)
      end
    end

    describe "GET consume" do
      it "gets consume" do
        get :consume

        expect(response).to redirect_to("http://SUCCESS.URL.HERE")
      end
    end
  end
end
