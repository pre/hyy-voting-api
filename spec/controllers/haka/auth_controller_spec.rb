require 'rails_helper'

module Haka
  RSpec.describe AuthController, type: :controller do
    describe "GET new" do
      it "gets new" do
        get :new

        # This will fail if HTTP Basic Auth is configured in .env
        expect(response).to be_redirect

        match_site_address = Regexp.new(Regexp.escape(Vaalit::Haka::SAML_IDP_SSO_TARGET_URL))
        expect(response).to redirect_to(match_site_address)
      end
    end

  end
end
