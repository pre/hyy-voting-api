include ERB::Util # for html_escape; TODO: Remove me

module Haka

  # Haka Authentication for a SAML Service Provider
  class AuthController < ApplicationController

    # Initiates a new SAML sign in request
    def new
      request = OneLogin::RubySaml::Authrequest.new
      redirect_to(request.create(saml_settings))
    end

    # HAKA:
    #
    # attrs: '#<OneLogin::RubySaml::Attributes:0x007fde1a7f3118
    # @attributes={
    #   "urn:oid:1.3.6.1.4.1.25178.1.2.14"=>["urn:schac:personalUniqueCode:fi:yliopisto.fi:x8734"],
    #   "urn:oid:0.9.2342.19200300.100.1.3"=>["teppo@nonexistent.tld"],
    #   "urn:oid:2.16.840.1.113730.3.1.241"=>["Teppo"]
    # }>'
    def consume
      response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], :settings => saml_settings)

      if !response.is_valid?
        raise "#todo authorization failed: #{response.errors}"
      end

      person = Person.new response.attributes[Vaalit::Haka::HAKA_STUDENT_NUMBER_FIELD]

      if person.valid?
        session_token = SessionToken.new person.voter

        # FIXME: Capybara tests:
        # 1) This must redirect_to the current environment's frontend.
        # 2) Angular needs to know which environment is wanted.
        #
        # Development: localhost:3000
        # Tests: localhost:3999
        # Prod: whatever
        #
        redirect_to "/#/sign-in?token=#{session_token.ephemeral_jwt}"
        # render text: "GREAT SUCCESS! VoterUser: #{h voter_user.inspect} - raw_student_number: #{h raw_student_number} <br> attrs: '#{h response.attributes.inspect}'"
        # render text: "GREAT SUCCESS! <br> attrs: '#{h response.attributes.inspect}'"
      else
        raise "#todo voter '#{person.inspect}' does not have right to vote'"
      end
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
