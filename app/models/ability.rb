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
    can :access, :elections
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
