class Payment < ActiveRecord::Base
  belongs_to :company
  belongs_to :employee
  validates_presence_of :company, :employee, :year, :month, :amount
  validates_uniqueness_of :employee, scope: [:company, :year, :month], :allow_nil => true
  validates :month, :inclusion => { :in => 1..12 }
  validates :year, :inclusion => { :in => 1900..2100 }
end
