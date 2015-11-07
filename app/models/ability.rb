class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= Voter.new # guest user (not logged in)
    set_role(user)
  end

  def admin(user)
    can :manage, :all
  end

  def voter(user)
    can :access, :ae_namespace

    if RuntimeConfig.vote_signin_active? || RuntimeConfig.voting_active?
      can :access, :elections
    end

    if RuntimeConfig.vote_signin_active? || RuntimeConfig.eligibility_signin_active?
      can :access, :sessions
    end

    if RuntimeConfig.voting_active?
      can :access, :votes
    end

    can :access, Election do |election|
      user.elections.any? { |e| e.id == election.id }
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
