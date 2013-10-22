class Transfer < ActiveRecord::Base
  belongs_to :company
  validates_presence_of :company, :transfer_date, :amount
end
