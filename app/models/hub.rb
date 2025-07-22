class Hub < ApplicationRecord
  acts_as_tenant :organization
  has_many :teams, dependent: :restrict_with_error
  has_one :address, as: :addressable, dependent: :destroy

  accepts_nested_attributes_for :address

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def self.ransackable_attributes(auth_object = nil)
    ["name"]
  end
end
