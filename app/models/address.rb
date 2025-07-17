class Address < ApplicationRecord
  belongs_to :addressable, polymorphic: true

  validates :street, :city, :country, presence: true
end
