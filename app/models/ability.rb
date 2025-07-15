class Ability
  include CanCan::Ability

  def initialize(user)
    AdministratorAbility.new(user, self) if user.is_a? (Administrator)
  end
end
