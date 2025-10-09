class DriverAbility
  def initialize(user, ability)
    ability.can :read, Task, driver_id: user.id
    ability.can :update, Task, driver_id: user.id
    ability.can :manage, Schedule, driver_id: user.id
    ability.can :manage, Subschedule, schedule: { driver_id: user.id }
  end
end
