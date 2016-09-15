module Haka

  # Haka Authentication for a SAML Service Provider
  class AuthController < ApplicationController

    # Initiates a new SAML sign in request
    def new
      request = OneLogin::RubySaml::Authrequest.new
      redirect_to(request.create(saml_settings))
    end

    # Receives the SAML assertion after Haka sign in
    def consume
      response = OneLogin::RubySaml::Response.new(params[:SAMLResponse],
                                                  settings: saml_settings,
                                                  allowed_clock_drift: 5.seconds)

      if !response.is_valid?
        raise "#todo authorization failed: #{response.errors}"
      end

      person = Person.new response.attributes[Vaalit::Haka::HAKA_STUDENT_NUMBER_FIELD]

      unless person.valid?
        raise "#todo voter '#{person.inspect}' does not have right to vote'"
      end

      redirect_to "/#/sign-in?token=#{SessionToken.new(person.voter).ephemeral_jwt}"
    end

    private
    begin

      def saml_settings
        settings = OneLogin::RubySaml::Settings.new

        # Require identity provider to (re)authenticate user also when a
        # previously authenticated session is still valid.
        settings.force_authn = true

        settings.idp_entity_id                  = Vaalit::Haka::SAML_IDP_ENTITY_ID
        settings.idp_sso_target_url             = Vaalit::Haka::SAML_IDP_SSO_TARGET_URL
        settings.assertion_consumer_service_url = Vaalit::Haka::SAML_ASSERTION_CONSUMER_SERVICE_URL
        settings.issuer                         = Vaalit::Haka::SAML_MY_ENTITY_ID
        settings.idp_cert                       = Vaalit::Haka::SAML_IDP_CERT
        settings.name_identifier_format         = Vaalit::Haka::SAML_NAME_IDENTIFIER_FORMAT

        settings.certificate                    = Vaalit::Haka::SAML_MY_CERT
        settings.private_key                    = Vaalit::Haka::SAML_MY_PRIVATE_KEY

        # Fingerprint can be used in local testing instead of a cert.
        # When SAML assertions are encrypted, an actual cert is required and
        # fingerprint can be left blank.
        if Vaalit::Haka::SAML_IDP_CERT_FINGERPRINT.present?
          settings.idp_cert_fingerprint         = Vaalit::Haka::SAML_IDP_CERT_FINGERPRINT
        end

        settings
      end

    end

  end
end
