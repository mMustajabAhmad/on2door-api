class Recipient < ApplicationRecord
  has_many :tasks, dependent: :nullify
  has_one :address, as: :addressable, dependent: :destroy

  validates :name, :phone_number, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ["id", "name", "phone_number"]
  end
end
