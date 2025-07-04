class Administrator < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :invitable, :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  belongs_to :organization
  after_invitation_accepted :activate_admin
  has_and_belongs_to_many :teams
  validates :is_account_owner, uniqueness: { scope: :organization_id }, if: :is_account_owner?

  enum :role, [ :owner, :admin, :dispatcher ]

  def activate_admin
    update(is_active: true)
  end
end
