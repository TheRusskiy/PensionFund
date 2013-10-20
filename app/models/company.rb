class Company < ActiveRecord::Base
  belongs_to :property_type
  has_many :contracts
  has_many :transfers
  has_many :employees, through: :contracts
end
