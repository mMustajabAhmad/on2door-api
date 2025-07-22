class AdministratorAbility
  def initialize(user, ability)
    if user.owner?
      ability.can :manage, Administrator
      ability.cannot :destroy, Administrator, id: user.id
      ability.can :create, Administrator, role: ['admin', 'dispatcher']
      ability.can :manage, Organization
      ability.can :manage, Team
      ability.can :manage, Hub
      ability.can :manage, Driver
    elsif user.admin?
      ability.can :read, Administrator
      ability.can :create, Administrator, role: ['admin', 'dispatcher']
      ability.cannot :show, Administrator, role: 'owner'
      ability.can :update, Administrator, role: ['admin', 'dispatcher']
      ability.can :destroy, Administrator, role: ['admin', 'dispatcher']
      ability.cannot :destroy, Administrator, id: user.id
      ability.can :manage, Organization
      ability.can :manage, Team
      ability.can :manage, Hub
      ability.can :manage, Driver
    elsif user.dispatcher?
      ability.can :index, Administrator, role: 'dispatcher', teams: { id: user.team_ids }
      ability.can :update, Administrator, id: user.id
      ability.can :read, Team, id: user.team_ids
      ability.can :create, Driver
      ability.can :read, Driver, teams: { id: user.team_ids }
      ability.can :update, Driver, teams: { id: user.team_ids }
      ability.can :destroy, Driver, teams: { id: user.team_ids }
    else
      ability.cannot :manage, :all
    end
  end
end
