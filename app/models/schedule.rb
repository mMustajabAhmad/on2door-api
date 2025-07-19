class Schedule < ApplicationRecord
  belongs_to :driver
  has_many :subschedules, dependent: :destroy
end
