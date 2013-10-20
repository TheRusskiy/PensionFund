require 'rspec'
require_relative '../spec_helper'

describe 'Employee' do
  let(:employee){build :employee}
  it 'should can be created' do
    employee.full_name.should match /Name_\d/
  end

  it 'has many payments' do
    employee_payments = create(:employee_with_payments)
    employee_payments.payments.size.should be > 0
  end

  it 'has many companies and contracts' do
    employee_companies = create(:employee_with_companies)
    employee_companies.companies.size.should be > 0

    employee_companies.contracts.size.should be > 0
  end
end