class AfterVoteMailer < ApplicationMailer
  def thank(voter)
    return unless voter.email.present?

    attachments['hyy_logo.png'] = File.read(
      Rails.root.join("app/assets/images/hyy_logo/hyy_logo_bw_500.png")
    )

    mail(
      :to => voter.email,
      :subject => 'HYY tarjoaa vaalikahvin'
    )
  end
  alias :thank_retry :thank
end
