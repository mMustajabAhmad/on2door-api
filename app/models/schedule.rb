class Schedule < ApplicationRecord
  belongs_to :driver
  has_many :subschedules, dependent: :destroy

  validates :date, presence: true
  validates :date, uniqueness: { scope: :driver_id }

  def self.ransackable_attributes(auth_object = nil)
    ["id", "date", "driver_id", "created_at", "updated_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["driver", "subschedules"]
  end
end
