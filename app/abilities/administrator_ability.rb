class AdministratorAbility
  def initialize(user, ability)
    if user.owner?
      ability.can :manage, Administrator, organization_id: user.organization_id
      ability.cannot :destroy, Administrator, id: user.id
      ability.can :create, Administrator, role: ['admin', 'dispatcher']
      ability.can :manage, Organization, id: user.organization_id
      ability.can :manage, Team, organization_id: user.organization_id
      ability.can :manage, Hub, organization_id: user.organization_id
    elsif user.admin?
      ability.can :read, Administrator, organization_id: user.organization_id
      ability.can :create, Administrator, role: ['admin', 'dispatcher']
      ability.cannot :show, Administrator, role: 'owner'
      ability.can :update, Administrator, organization_id: user.organization_id, role: ['admin', 'dispatcher']
      ability.can :destroy, Administrator, organization_id: user.organization_id, role: ['admin', 'dispatcher']
      ability.cannot :destroy, Administrator, id: user.id
      ability.can :manage, Organization, id: user.organization_id
      ability.can :manage, Team, organization_id: user.organization_id
      ability.can :manage, Hub, organization_id: user.organization_id
    elsif user.dispatcher?
      ability.can :index, Administrator, role: 'dispatcher', teams: { id: user.team_ids }
      ability.can :update, Administrator, id: user.id
      ability.can :read, Team, id: user.team_ids
    else
      ability.cannot :manage, :all
    end
  end
end
