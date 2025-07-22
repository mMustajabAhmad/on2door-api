class Driver < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  acts_as_tenant :organization
  has_and_belongs_to_many :teams, dependent: :nullify
  has_many :schedules, dependent: :destroy
  has_many :subschedules, through: :schedules

  after_invitation_accepted :activate_driver

  def self.ransackable_attributes(auth_object = nil)
    ["capacity", "display_name", "email", "first_name", "id", "invited_by_type", "is_active", "last_name", "on_duty", "organization_id", "phone_number"]
  end

  def assign_pending_teams
    return unless pending_team_ids.present?
    self.teams = Team.where(id: pending_team_ids)
    update(pending_team_ids: nil)
  end

  def activate_driver
    update(is_active: true)
  end
end
