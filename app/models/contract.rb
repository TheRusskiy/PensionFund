class Contract < ActiveRecord::Base
  belongs_to :employee
  belongs_to :company
  belongs_to :job_position
end
