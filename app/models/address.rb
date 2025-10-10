class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :street, :city, :state, :country, presence: true
  validates :latitude, :longitude, presence: true, on: :update

  def self.ransackable_attributes(auth_object = nil)
    %w[street city state postal_code country]
  end

  geocoded_by :full_address
  after_validation :geocode, if: :address_changed?

  def full_address
    [street, city, state, appartment, postal_code, country].compact.join(', ')
  end

  private
    def address_changed?
      street_changed? || street_number_changed? || appartment_changed? || city_changed? || state_changed? || postal_code_changed? || country_changed?
    end
end
