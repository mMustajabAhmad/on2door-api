class Administrator < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher
  belongs_to :organization
  accepts_nested_attributes_for :organization
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  enum role: {
    owner: 0, 
    admin: 1, 
    dispatcher: 2
  }
end
