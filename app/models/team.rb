class Team < ApplicationRecord
  acts_as_tenant :organization
  belongs_to :hub, optional: true
  has_and_belongs_to_many :administrators, dependent: :nullify
  has_and_belongs_to_many :drivers, dependent: :nullify

  def self.ransackable_attributes(auth_object = nil)
    ["id", "hub_id", "name", "organization_id"]
  end

  validates :name, presence: true, uniqueness: { case_sensitive: false, scope: :organization_id }

  def dispatchers_count
    administrators&.dispatcher&.count
  end

  def drivers_count
    drivers&.count
  end
end
