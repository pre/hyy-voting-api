require 'rails_helper'

module Haka
  RSpec.describe SpSessionController, type: :controller do
    routes { Haka::Engine.routes }

    describe "GET new" do

      it "gets new" do
        get :new

        expect(response).to be_redirect

        match_site_address = Regexp.new(Regexp.escape(Haka::Config::SAML_IDP_SSO_TARGET_URL))
        expect(response).to redirect_to(match_site_address)
      end
    end

  end
end
