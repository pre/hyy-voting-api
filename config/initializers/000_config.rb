# Start-time configuration which does not change during the runtime.
# For dynamic configuration, see `app/models/runtime_config.rb`
module Vaalit

  module Public
    SITE_ADDRESS        = ENV.fetch('SITE_ADDRESS')
    EMAIL_FROM_ADDRESS  = ENV.fetch('EMAIL_FROM_ADDRESS')
    EMAIL_FROM_NAME     = ENV.fetch('EMAIL_FROM_NAME')
    EXTERNAL_INFO_SITE  = ENV.fetch('EXTERNAL_INFO_SITE')
    EXTERNAL_INFO_PHONE = ENV.fetch('EXTERNAL_INFO_PHONE')
  end

  module Config
    IS_EDARI_ELECTION            = !!(ENV.fetch('IS_EDARI_ELECTION') =~ /true/)
    IS_HALLOPED_ELECTION         = !IS_EDARI_ELECTION
    VOTE_SIGNIN_STARTS_AT        = Time.parse ENV.fetch('VOTE_SIGNIN_STARTS_AT')
    VOTE_SIGNIN_ENDS_AT          = Time.parse ENV.fetch('VOTE_SIGNIN_ENDS_AT')
    ELIGIBILITY_SIGNIN_STARTS_AT = Time.parse ENV.fetch('ELIGIBILITY_SIGNIN_STARTS_AT')
    ELIGIBILITY_SIGNIN_ENDS_AT   = Time.parse ENV.fetch('ELIGIBILITY_SIGNIN_ENDS_AT')
    VOTING_GRACE_PERIOD_MINUTES  = ENV.fetch('VOTING_GRACE_PERIOD_MINUTES').to_i.minutes
    MAIL_BCC_ADDRESS             = ENV.fetch('MAIL_BCC_ADDRESS')
    SESSION_JWT_EXPIRY_MINUTES   = ENV.fetch('SESSION_JWT_EXPIRY_MINUTES').to_i.minutes
  end

  module Haka
    SAML_NAME_IDENTIFIER_FORMAT         = "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"

    SAML_IDP_SSO_TARGET_URL             = ENV.fetch("SAML_IDP_SSO_TARGET_URL")
    SAML_IDP_ENTITY_ID                  = ENV.fetch("SAML_IDP_ENTITY_ID")
    SAML_IDP_CERT_FINGERPRINT           = ENV.fetch("SAML_IDP_CERT_FINGERPRINT")
    SAML_IDP_CERT                       = ENV.fetch("SAML_IDP_CERT")

    SAML_ASSERTION_CONSUMER_SERVICE_URL = ENV.fetch("SAML_ASSERTION_CONSUMER_SERVICE_URL")

    SAML_MY_ENTITY_ID                   = ENV.fetch("SAML_MY_ENTITY_ID")
    SAML_MY_CERT                        = ENV.fetch("SAML_MY_CERT")
    SAML_MY_PRIVATE_KEY                 = ENV.fetch("SAML_MY_PRIVATE_KEY")

    HAKA_STUDENT_NUMBER_FIELD           = ENV.fetch("HAKA_STUDENT_NUMBER_FIELD")
  end

  module Frontend
    API_BASE_URL         = ENV.fetch("FRONTEND_API_BASE_URL")
    ROLLBAR_ACCESS_TOKEN = ENV.fetch("FRONTEND_ROLLBAR_ACCESS_TOKEN")
    ROLLBAR_ENVIRONMENT  = ENV.fetch("FRONTEND_ROLLBAR_ENVIRONMENT")
    GOOGLE_ANALYTICS_ID  = ENV.fetch("FRONTEND_GOOGLE_ANALYTICS_ID")
  end

end
