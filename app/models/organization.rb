class Organization < ApplicationRecord
  include CountryTimezone
  has_many :administrators, dependent: :destroy
  has_many :drivers, dependent: :destroy
  has_many :teams, dependent: :destroy
  has_many :hubs, dependent: :destroy

  validates :name, presence: true, uniqueness: { case_sensitive: false }
  before_validation :set_timezone_from_country

  delegate :owner, :admin, :dispatcher, to: :administrators

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

  private
    def set_timezone_from_country
      return if country.blank?
      tz = timezone_for_country(country)
      if tz.nil?
        errors.add(:country, "is invalid. Please use the official English country name or 2-letter code.")
      else
        self.timezone = tz
      end
    end
end
