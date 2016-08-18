class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Voter.new # guest user (not logged in)
    set_role(user)
  end

  def admin(user)
    can :manage, :all
  end

  # For simplicity, only :access is used as a keyword for each ACL target.
  def voter(user)
    if Vaalit::Config::IS_HALLOPED_ELECTION
      can :access, :ae_namespace
    end

    if RuntimeConfig.vote_signin_active? || RuntimeConfig.voting_active?
      can :access, :elections
    end

    if RuntimeConfig.vote_signin_active? || RuntimeConfig.eligibility_signin_active?
      can :access, :sessions
    end

    if RuntimeConfig.voting_active?
      can :access, :votes
    end

    # Restrict user access in multiple Halloped elections, but
    # allow access to all (=only one at a time) Edari Elections.
    if Vaalit::Config::IS_EDARI_ELECTION
      can :access, Election
    elsif Vaalit::Config::IS_HALLOPED_ELECTION
      can :access, Election do |election|
        user.elections.any? { |e| e.id == election.id }
      end
    end

  end

  private

  def set_role(user)
    case user.class.to_s
    when "Voter"
      send :voter, user
    when "AdminUser"
      send :admin, user
    else
      raise "Unknown user class: #{user.class.to_s}"
    end
  end
end
