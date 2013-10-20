class Payment < ActiveRecord::Base
  belongs_to :company
  belongs_to :employee
end
