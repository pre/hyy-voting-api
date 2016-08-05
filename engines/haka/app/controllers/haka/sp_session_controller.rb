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
    # @attributes={"urn:oid:1.3.6.1.4.1.25178.1.2.14"=>
    # ["urn:schac:personalUniqueCode:fi:yliopisto.fi:x8734"],
    #   "urn:oid:0.9.2342.19200300.100.1.3"=>["teppo@nonexistent.tld"],
    #   "urn:oid:2.16.840.1.113730.3.1.241"=>["Teppo"]}>'
    def consume
      response = OneLogin::RubySaml::Response.new(params[:SAMLResponse], :settings => saml_settings)

      if response.is_valid?
        student_id_field = "http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress"
        student_id = response.attributes[student_id_field]

        render text: "GREAT SUCCESS! student_id: #{h student_id} <br> attrs: '#{h response.attributes.inspect}'"
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

        settings.idp_entity_id = "http://localhost:4000/saml/auth"
        settings.idp_sso_target_url = "http://localhost:4000/saml/auth"

        settings.assertion_consumer_service_url = "http://localhost:3000/haka/sp_session/consume"
        settings.issuer                         = "http://localhost:3000/"

        settings.name_identifier_format         = "urn:oasis:names:tc:SAML:2.0:nameid-format:persistent"

        # ruby-saml-idp example cert
        settings.idp_cert_fingerprint           = "9E:65:2E:03:06:8D:80:F2:86:C7:6C:77:A1:D9:14:97:0A:4D:F4:4D" # https://github.com/lawrencepit/ruby-saml-idp

        settings
      end

    end
  end
end
