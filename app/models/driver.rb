class Driver < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  after_invitation_accepted :activate_driver
  has_and_belongs_to_many :teams, join_table: :drivers_teams

  def activate_driver
    update(is_active: true)
  end
end
