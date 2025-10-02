class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :street, :city, :country, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[street city state postal_code country]
  end
end
