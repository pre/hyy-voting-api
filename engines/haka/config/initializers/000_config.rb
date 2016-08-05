module Haka
  module Config
    SAML_IDP_SSO_TARGET_URL             = ENV.fetch("SAML_IDP_SSO_TARGET_URL")
    SAML_IDP_ENTITY_ID                  = ENV.fetch("SAML_IDP_ENTITY_ID")
    SAML_ASSERTION_CONSUMER_SERVICE_URL = ENV.fetch("SAML_ASSERTION_CONSUMER_SERVICE_URL")
    SAML_ISSUER                         = ENV.fetch("SAML_ISSUER")
    SAML_IDP_CERT_FINGERPRINT           = ENV.fetch("SAML_IDP_CERT_FINGERPRINT")

    SAML_NAME_IDENTIFIER_FORMAT = "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"

    HAKA_STUDENT_NUMBER_FIELD   = ENV.fetch("HAKA_STUDENT_NUMBER_FIELD")

  end
end
