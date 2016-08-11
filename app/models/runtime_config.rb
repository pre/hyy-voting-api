# Dynamic configuration which changes during the runtime.
# For static configuration, see `config/initializers/000_config.rb`
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

  # Allow a grace period to submit votes.
  # Only for users who have signed in before the sign in ended.
  def self.voting_active?
    now = Time.now

    Vaalit::Config::VOTE_SIGNIN_STARTS_AT <= now &&
      Time.now <= Vaalit::Config::VOTE_SIGNIN_ENDS_AT + Vaalit::Config::VOTING_GRACE_PERIOD_MINUTES
  end

end
