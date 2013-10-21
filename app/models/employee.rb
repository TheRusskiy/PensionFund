class Employee < ActiveRecord::Base
  has_many :payments
  has_many :contracts
  has_many :companies, through: :contracts
  validates_presence_of :full_name
end
