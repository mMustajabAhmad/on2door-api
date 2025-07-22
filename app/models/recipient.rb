class Recipient < ApplicationRecord
  has_many :tasks, dependent: :nullify
end