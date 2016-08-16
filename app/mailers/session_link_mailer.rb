class SessionLinkMailer < ApplicationMailer
  default :from => "#{Vaalit::Public::EMAIL_FROM_NAME} <#{Vaalit::Public::EMAIL_FROM_ADDRESS}>"

  def signup_link(email, url)
    @site_address = Vaalit::Public::SITE_ADDRESS
    @url = url

    mail(
      :to => email,
      :subject => 'Sisäänkirjautumislinkki hallintovaaleihin'
    )
  end
end
