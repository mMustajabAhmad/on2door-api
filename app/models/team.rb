class Team < ApplicationRecord
  belongs_to :organization
  belongs_to :hub, optional: true

  has_and_belongs_to_many :administrators, join_table: :administrators_teams
  has_and_belongs_to_many :drivers, join_table: :drivers_teams

  validates :name, presence: true
end
