module Vaalit

  module Public
    SITE_ADDRESS        = ENV.fetch('SITE_ADDRESS')
    EMAIL_FROM_ADDRESS  = ENV.fetch('EMAIL_FROM_ADDRESS')
    EMAIL_FROM_NAME     = ENV.fetch('EMAIL_FROM_NAME')
    EXTERNAL_INFO_SITE  = ENV.fetch('EXTERNAL_INFO_SITE')
    EXTERNAL_INFO_PHONE = ENV.fetch('EXTERNAL_INFO_PHONE')
  end

  module Config
    SIGNIN_STARTS_AT             = Time.parse ENV.fetch('SIGNIN_STARTS_AT')
    SIGNIN_ENDS_AT               = Time.parse ENV.fetch('SIGNIN_ENDS_AT')
    VOTING_GRACE_PERIOD_MINUTES  = ENV.fetch('VOTING_GRACE_PERIOD_MINUTES').to_i.minutes
  end

end
