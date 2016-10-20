class ApplicationMailer < ActionMailer::Base
  default :from => "#{Vaalit::Public::EMAIL_FROM_NAME} <#{Vaalit::Public::EMAIL_FROM_ADDRESS}>"

  layout 'mailer'
end
