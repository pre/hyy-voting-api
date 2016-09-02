# Dynamic configuration which changes during the runtime.
# For static configuration, see `config/initializers/000_config.rb`
class RuntimeConfig

  # User can sign in to check his eligibility in Halloped elections.
  def self.eligibility_signin_active?
    now = Time.now

    Vaalit::Config::ELIGIBILITY_SIGNIN_STARTS_AT <= now &&
      now <= Vaalit::Config::ELIGIBILITY_SIGNIN_ENDS_AT
  end

  # User can sign in to vote.
  def self.vote_signin_active?
    now = Time.now

    voting_day?(now) && voting_time?(now)
  end

  # User can submit a vote.
  #
  # Allow a grace period to submit votes.
  # Only for users who have signed in before the sign in ended.
  def self.voting_active?
    now = Time.now

    signin_has_started?(now) &&
      now <= voting_ends_at? &&
      voting_time_with_grace_period?(now)
  end

  private_class_method def self.signin_has_started?(now)
    Vaalit::Config::VOTE_SIGNIN_STARTS_AT <= now
  end

  private_class_method def self.voting_day?(now)
    signin_has_started?(now) && now <= Vaalit::Config::VOTE_SIGNIN_ENDS_AT
  end

  private_class_method def self.voting_time?(now)
    now <= Time.parse(Vaalit::Config::VOTE_SIGNIN_DAILY_CLOSING_TIME)
  end

  private_class_method def self.voting_time_with_grace_period?(now)
    now <= Time.parse(Vaalit::Config::VOTE_SIGNIN_DAILY_CLOSING_TIME) + Vaalit::Config::VOTING_GRACE_PERIOD_MINUTES
  end

  private_class_method def self.voting_ends_at?
    Vaalit::Config::VOTE_SIGNIN_ENDS_AT + Vaalit::Config::VOTING_GRACE_PERIOD_MINUTES
  end
end
