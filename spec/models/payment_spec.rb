require 'rspec'
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

end