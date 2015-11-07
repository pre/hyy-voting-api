class RuntimeConfig

  def self.eligibility_signin_active?
    now = Time.now

    Vaalit::Config::ELIGIBILITY_SIGNIN_STARTS_AT <= now &&
      now <= Vaalit::Config::ELIGIBILITY_SIGNIN_ENDS_AT
  end

  def self.vote_signin_active?
    now = Time.now

    Vaalit::Config::VOTE_SIGNIN_STARTS_AT <= now &&
      now <= Vaalit::Config::VOTE_SIGNIN_ENDS_AT
  end

  def self.voting_active?
    Time.now < Vaalit::Config::VOTE_SIGNIN_ENDS_AT + Vaalit::Config::VOTING_GRACE_PERIOD_MINUTES
  end

end
