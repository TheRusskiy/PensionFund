class Contract < ActiveRecord::Base
  belongs_to :employee
  belongs_to :company
  belongs_to :job_position
  validates_presence_of :employee, :company, :job_position
  # without allow_nil validator will die on nil records,
  # presence_of filters out nil fields anyway:
  validates_uniqueness_of :employee, scope: :company, :allow_nil => true

  def to_s
    employee.full_name+' > '+company.name+' > '+job_position.name
  end
end
