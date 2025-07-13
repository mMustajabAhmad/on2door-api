class Organization < ApplicationRecord
  has_many :administrators, dependent: :destroy
  has_many :drivers, dependent: :destroy
  has_many :teams, dependent: :destroy

  enum :monthly_delivery_volume, [
    :range_0_100,
    :range_101_2000,
    :range_2001_5000,
    :range_5001_12500,
    :range_12501_plus
  ]

  enum :primary_industry, [
    :construction,
    :grocery,
    :pharmacy,
    :preparedfood,
    :restaurants,
    :retail,
    :others
  ]

  def owner
    administrators.owner
  end

  def admins
    administrators.admin
  end

  def dispatchers
    administrators.dispatcher
  end
end
