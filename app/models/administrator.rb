class Administrator < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  acts_as_tenant :organization
  has_and_belongs_to_many :teams, dependent: :nullify
  has_many :tasks, dependent: :nullify

  after_invitation_accepted :activate_admin

  accepts_nested_attributes_for :organization

  validates :phone_number, uniqueness: { scope: :organization_id }

  enum :role, [ :owner, :admin, :dispatcher ]

  scope :admins_and_owners, -> { where(role: ['owner', 'admin']) }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "email", "first_name", "last_name", "invitation_accepted_at", "is_account_owner", "is_active", "is_read_only", "organization_id", "phone_number", "role"]
  end

  def assign_pending_teams
    return unless pending_team_ids.present?
    self.teams = Team.where(id: pending_team_ids)
    update(pending_team_ids: nil)
  end

  def activate_admin
    update(is_active: true)
  end
end
