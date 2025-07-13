class Administrator < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  belongs_to :organization
  accepts_nested_attributes_for :organization
  after_invitation_accepted :activate_admin
  has_and_belongs_to_many :teams, join_table: :administrators_teams

  enum :role, [ :owner, :admin, :dispatcher ]

  def self.ransackable_attributes(auth_object = nil)
    ["id", "email", "first_name", "last_name", "invitation_accepted_at", "is_account_owner", "is_active", "is_read_only", "organization_id", "phone_number", "role"]
  end

  def activate_admin
    update(is_active: true)
  end
end
