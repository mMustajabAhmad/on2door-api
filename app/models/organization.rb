class Organization < ApplicationRecord
  has_many :administrators, dependent: :destroy
  has_many :drivers, dependent: :destroy
  has_many :teams, dependent: :destroy

  enum monthly_delivery_volume: {
    range_0_100: 0,
    range_101_2000: 1,
    range_2001_5000: 2,
    range_5001_12500: 3,
    range_12501_plus: 4
  }

  enum primary_industry: {
    construction: 0, 
    grocery: 1, 
    pharmacy: 2, 
    preparedfood: 3, 
    restaurants: 4, 
    retail: 5, 
    others: 6
  }

  def org_owner
    administrators.owner
  end
end
