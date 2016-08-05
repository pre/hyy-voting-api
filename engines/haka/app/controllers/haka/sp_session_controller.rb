require_dependency "haka/application_controller"

include ERB::Util # for html_escape; TODO: Remove me

# Service Provider
module Haka
  class SpSessionController < ApplicationController

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

      if response.is_valid?
        voter_user = VoterUser.new response.attributes[Haka::Config::HAKA_STUDENT_NUMBER_FIELD]

        render text: "GREAT SUCCESS! VoterUser: #{h voter_user.inspect} - raw_student_number: #{h raw_student_number} <br> attrs: '#{h response.attributes.inspect}'"
      else
        raise "#todo authorization failed: #{response.errors}"
      end
    end

    def ping
      render plain: "pong"
    end

    private
    begin

      # Haka test url:
      # https://localhost.enemy.fi:3001/haka/sp_session/new
      def saml_settings
        settings = OneLogin::RubySaml::Settings.new

        settings.idp_entity_id = Haka::Config::SAML_IDP_ENTITY_ID
        settings.idp_sso_target_url = Haka::Config::SAML_IDP_SSO_TARGET_URL

        settings.assertion_consumer_service_url = Haka::Config::SAML_ASSERTION_CONSUMER_SERVICE_URL
        settings.issuer                         = Haka::Config::SAML_ISSUER
        settings.idp_cert_fingerprint           = Haka::Config::SAML_IDP_CERT_FINGERPRINT
        settings.name_identifier_format         = Haka::Config::SAML_NAME_IDENTIFIER_FORMAT

        settings
      end

    end
  end
end
