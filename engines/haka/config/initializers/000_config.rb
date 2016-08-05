module Haka
  module Config
    SAML_IDP_SSO_TARGET_URL = ENV.fetch("SAML_IDP_SSO_TARGET_URL")
    SAML_IDP_ENTITY_ID = ENV.fetch("SAML_IDP_ENTITY_ID")
  end
end
