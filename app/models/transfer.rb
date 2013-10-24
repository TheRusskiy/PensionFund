class Transfer < ActiveRecord::Base
  belongs_to :company
  validates_presence_of :company, :transfer_date, :amount, :month, :year
  validates :month, :inclusion => { :in => 1..12 }, :allow_nil => true
  validates :year, :inclusion => { :in => 1900..2100 }, :allow_nil => true

  def to_s
    company.name+': '+transfer_date
  end
end
