class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= GuestUser.new
    set_role(user)
  end

  # Internal services, eg Vaalitulostin
  def service_user(_user)
    can :access, :stats
    can :access, :export unless RuntimeConfig.elections_active?
    can :access, :voters if RuntimeConfig.elections_started? && RuntimeConfig.elections_active?
  end

  # Someone who doesn't (yet) have a valid JWT API token.
  def guest_user(_user)
    if RuntimeConfig.vote_signin_active?
      can :access, :sessions
    end
  end

  # For simplicity, only :access is used as a keyword for each ACL target.
  def voter(user)
    if RuntimeConfig.vote_signin_active? || RuntimeConfig.voting_active?
      can :access, :elections
      can :access, Election
    end

    if RuntimeConfig.voting_active?
      can :access, :votes
    end
  end

  private

  def set_role(user)
    case user.class.to_s
    when "GuestUser"
      send :guest_user, user
    when "Voter"
      send :voter, user
    when "ServiceUser"
      send :service_user, user
    else
      raise "Unknown user class: #{user.class.to_s}"
    end
  end
end
