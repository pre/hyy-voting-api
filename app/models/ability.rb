class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= GuestUser.new
    set_role(user)
  end

  # Internal services, eg Vaalitulostin
  def service_user(_user)
    can :access, :export unless RuntimeConfig.elections_active?
    can :access, :voters
  end

  # Someone who doesn't (yet) have a valid JWT API token.
  def guest_user(_user)
    if RuntimeConfig.vote_signin_active? || RuntimeConfig.eligibility_signin_active?
      can :access, :sessions
    end
  end

  # For simplicity, only :access is used as a keyword for each ACL target.
  def voter(user)
    if Vaalit::Config::IS_HALLOPED_ELECTION
      can :access, :ae_namespace
    end

    if RuntimeConfig.vote_signin_active? || RuntimeConfig.voting_active?
      can :access, :elections

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
