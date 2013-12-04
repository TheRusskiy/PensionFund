class Company < ActiveRecord::Base
  belongs_to :property_type
  has_many :contracts
  has_many :transfers
  has_many :payments
  has_many :employees, through: :contracts
  validates_uniqueness_of :vat, :name
  validates_presence_of :name, :vat, :property_type

  def to_s
    name
  end
end
