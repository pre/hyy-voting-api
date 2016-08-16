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
        redirect_to "/#/sign-in?token=#{session_token.jwt}"
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

        settings.force_authn = true

        settings.idp_entity_id                  = Vaalit::Haka::SAML_IDP_ENTITY_ID
        settings.idp_sso_target_url             = Vaalit::Haka::SAML_IDP_SSO_TARGET_URL
        settings.assertion_consumer_service_url = Vaalit::Haka::SAML_ASSERTION_CONSUMER_SERVICE_URL
        settings.issuer                         = Vaalit::Haka::SAML_MY_ENTITY_ID
        # settings.idp_cert_fingerprint           = Vaalit::Haka::SAML_IDP_CERT_FINGERPRINT
        # settings.idp_cert                       = Vaalit::Haka::SAML_IDP_CERT
        settings.idp_cert = "MIIFsjCCBJqgAwIBAgIRAOzQGzkFwQfc63S2noajY1AwDQYJKoZIhvcNAQEFBQAw
NjELMAkGA1UEBhMCTkwxDzANBgNVBAoTBlRFUkVOQTEWMBQGA1UEAxMNVEVSRU5B
IFNTTCBDQTAeFw0xNDA0MDkwMDAwMDBaFw0xNzA0MDgyMzU5NTlaMD4xITAfBgNV
BAsTGERvbWFpbiBDb250cm9sIFZhbGlkYXRlZDEZMBcGA1UEAxMQdGVzdGlkcC5m
dW5ldC5maTCCAiIwDQYJKoZIhvcNAQEBBQADggIPADCCAgoCggIBANLsWnvGMqqr
QCouEsmLYukOg12mgy7ZuJI9njkXQusO6tUAtbg0UW4mk/ms8vWSyXG/y/I6KJHU
tGcT+6Fq3iAXFY76GWTyWIckePsJnaaaqWq7RJPWq+GAsbWXpCc1M7osvy7HPJ7k
5fa/FaunaXK/hjDmDcrB4FqxlzmPatnHNRNCiX7GJVo3X8QAQPmWd9yoqYjIS05G
hYCs9TEpqpktpx7zdNb6scBVMtBAi7KO6aq1A7JVXMMXhFjxrEskmTCNTIfb306L
65jZwaLD6DrEIV8nGTPWabtwSxg5kZjLKdMOZBo9R1PGduS0MwAxIzzfnoPUhMVH
DjuJ+l8Fh4S3+2oQUoddoA1LpocWrLwuOF7vd/mfRH6ab3ZcRpPU1l/f1HTD6B3w
+0dBXmxSK6lU0ZNmua7Rjvni9F9c01LoxGckxBEC8Lk0YtFeKcZ5aET9Gu4haH+i
dyFV6G+AIaZtiTtgPGMGETgHPOxZI+HuwbUOsHYP3GWRAyqnSagrdRVDAhAc/YXM
YlsNRMLc/H7tqqb3lDkC3NmKSl03oIpz8PMnVs/qe2dCKF9b3QKmB4VmllEc+gSH
AViCHgPu5AHUsJEqkIXMrSaV2Q4dN5B0QzQBgUdGblFYaojzh2K7v8R45ASvgrFv
3Wi1lgjQ7f8Deb5zzwM36eGsOqyJbEihAgMBAAGjggGxMIIBrTAfBgNVHSMEGDAW
gBQMvZNoDPPeq6NJays3V0fqkOO57TAdBgNVHQ4EFgQUBaEGyfLKUS2VqDQbmOTE
aTS3w20wDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYwFAYI
KwYBBQUHAwEGCCsGAQUFBwMCMCIGA1UdIAQbMBkwDQYLKwYBBAGyMQECAh0wCAYG
Z4EMAQIBMDoGA1UdHwQzMDEwL6AtoCuGKWh0dHA6Ly9jcmwudGNzLnRlcmVuYS5v
cmcvVEVSRU5BU1NMQ0EuY3JsMG0GCCsGAQUFBwEBBGEwXzA1BggrBgEFBQcwAoYp
aHR0cDovL2NydC50Y3MudGVyZW5hLm9yZy9URVJFTkFTU0xDQS5jcnQwJgYIKwYB
BQUHMAGGGmh0dHA6Ly9vY3NwLnRjcy50ZXJlbmEub3JnMF8GA1UdEQRYMFaCEHRl
c3RpZHAuZnVuZXQuZmmCFWhha2EtdGVzdGlkcC5mdW5ldC5maYIXaGFrYS10ZXN0
aWRwMDEuZnVuZXQuZmmCEnRlc3RpZHAwMS5mdW5ldC5maTANBgkqhkiG9w0BAQUF
AAOCAQEAA5UofICyl+6nrcBoUhCzfb79er8wVVM0q7L6MIDDgrZ4Ct6NJ68yAHpB
f16an25FPYRlsSX5IyKj/AQfmucMNiFPv/0R2pWOb7mDqguXmfEmKBoPFVe67kDg
kNNGHLr6niYnHKyuU7zv698UHlMsB2NMYQn67lWcwFiyP8eMf1nXvAgnWa0w1Ely
9Ybga57QmQoAHXDUD1ZHyTv1FLnJUCjtT0WZuVsipOrOXOKkcUSOyY5p2MXd+oeN
/gIMMEpdv27oUTxmBazCa07zYxrOTJRnM6cxDshLEVli8tlZXIs3rtbDcZm1L6pK
251WovfA5a8SqhyLDSIkXFWqilNkbg=="

        settings.name_identifier_format         = Vaalit::Haka::SAML_NAME_IDENTIFIER_FORMAT

        settings.certificate = "-----BEGIN CERTIFICATE-----
MIICazCCAdQCCQCYwK7kkX+hGjANBgkqhkiG9w0BAQUFADB6MQswCQYDVQQGEwJG
STETMBEGA1UECBMKU29tZS1TdGF0ZTEeMBwGA1UEChMVSFlZIFRlc3Rpb3JnYW5p
c2FhdGlvMRswGQYDVQQDExJsb2NhbGhvc3QuZW5lbXkuZmkxGTAXBgkqhkiG9w0B
CQEWCnByZUBpa2kuZmkwHhcNMTYwODAyMDk0MjIzWhcNMjYwNzMxMDk0MjIzWjB6
MQswCQYDVQQGEwJGSTETMBEGA1UECBMKU29tZS1TdGF0ZTEeMBwGA1UEChMVSFlZ
IFRlc3Rpb3JnYW5pc2FhdGlvMRswGQYDVQQDExJsb2NhbGhvc3QuZW5lbXkuZmkx
GTAXBgkqhkiG9w0BCQEWCnByZUBpa2kuZmkwgZ8wDQYJKoZIhvcNAQEBBQADgY0A
MIGJAoGBAK6VSx3QBjOJ80IZXmLR/sgtWOiZl8kNYh98pbMdeHLnwBkJBIAbp9GT
c3lagLMzO8sTE5u0Z1d55D1m3UjE7n8UZE7YvK4UBrprNKyiLzNjOOZHbC2t0+z7
UVwqyjyzwVJ08k/Mr5xu3/1WMV/gB7Ixw657ZDJWY4kMLKsTYI+9AgMBAAEwDQYJ
KoZIhvcNAQEFBQADgYEAjpZTSTH4st+rNEI+2YkIK/TEu1XmJk0fnSUfpkYkdQUH
XI+lU3+EuAu7QbLzFRQ8S61CLAuu2XfQNq8hGrlKAUS+lrkzgBE/5PkvNr3SuASd
vxVsiyKaPf5A2stUU94pZa554nvSNEIQwCoMtQ8vt3/fPx/fLgcLEcbuaUGih1k=
-----END CERTIFICATE-----"

        settings.private_key = "-----BEGIN RSA PRIVATE KEY-----
MIICXAIBAAKBgQCulUsd0AYzifNCGV5i0f7ILVjomZfJDWIffKWzHXhy58AZCQSA
G6fRk3N5WoCzMzvLExObtGdXeeQ9Zt1IxO5/FGRO2LyuFAa6azSsoi8zYzjmR2wt
rdPs+1FcKso8s8FSdPJPzK+cbt/9VjFf4AeyMcOue2QyVmOJDCyrE2CPvQIDAQAB
AoGAVxMRPxJVNXl1gZ9Di0gvqkmr0X9hzB5HtWqm/noRbEYYcqQjwX2Jqya+7mTs
UfSYuwWNvxgwftnFs7ZNYhEO3jIPayOexawYIjjMgXPUDotBn/EkRp76YSeG0SCo
FFCxpYghxRkM0U3Me79l88ujAoI0Letc/LSWTFIpjp8+AiECQQDcKaSf6s1tHb+J
LFP09fUhhIMw734wooZ7W2VBTYP90o4ibJZVQHV7wJZXjkymRmDxunEHL17eY9A4
kcqzvHKlAkEAywBQ5jfIje2PJf3lj7WMLGKO6K9D+KWFt+dsZuOp6QUsDJrgZG1L
EL6SoHwYK7TRDHs9WQ3Up5nWiXw3Zx2VOQJBANJIZBjqJ/PEqiDW2gnqsoulCbk/
xoOleFVyYjARXbSd22w90wjyXEQrGm3eWI+oQQghT7vRHwfCxiqB9d3ebJECQB/a
0NcPcd0zpf7kNJ20c2aToLFKr3PZJX6SRiRvHT5/nUXtF8EqlVjvTrr4PiK9oQBA
ZoQO84vJTC0O3PLFZaECQAruca/Q3ZKgLB95zOBnqKYJCEq8qaqx4MPEU+5w/uuw
D73tssNZcIGsQp8dGs4HZPVGkfGaE9UtDh72eUku6w0=
-----END RSA PRIVATE KEY-----"

        settings
      end

    end

  end
end
