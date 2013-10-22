require_relative '../spec_helper'

describe 'Payment' do
  let(:payment) {build(:payment)}
  it 'should be created' do
    payment.should_not be_nil
    payment.amount.should be > 0
  end

  it 'has correct associations' do
    payment.employee.full_name.should match /Name_\d+/
    payment.company.name.should match /Company_\d+/
  end

  it 'has unique company-employee-year-month' do
    p1 = create :payment
    p2 = build :payment, company: p1.company, employee: p1.employee, year: p1.year, month: p1.month
    p2.should be_invalid
    lambda {p2.save!}.should raise_error
  end

  it 'must have company, employee, year, month, amount' do
    build(:payment, company: nil).should be_invalid
    build(:payment, employee: nil).should be_invalid
    build(:payment, year: nil).should be_invalid
    build(:payment, month: nil).should be_invalid
    build(:payment, amount: nil).should be_invalid
  end

end