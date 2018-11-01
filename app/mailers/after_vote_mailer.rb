class AfterVoteMailer < ApplicationMailer
  def thank(voter)
    return unless voter.email.present?

    attachments['hyy_logo.png'] = File.read(
      Rails.root.join("app/assets/images/hyy_logo/hyy_seppele_300.png")
    )

    mail(
      :to => voter.email,
      :subject => 'HYY tarjoaa vaalikahvin'
    )
  end
  alias :thank_retry :thank
end
