class Vehicle < ApplicationRecord
  belongs_to :driver

  validates :license_plate, presence: true
  validates :vehicle_type, presence: true

  enum :vehicle_type, [
    :car,
    :van,
    :truck,
    :motorcycle,
    :bicycle
  ]

  def self.ransackable_attributes(auth_object = nil)
   %w[ id license_plate vehicle_type color description driver_id ]
  end

  def self.ransackable_associations(auth_object = nil)
    %w[driver]
  end
end
