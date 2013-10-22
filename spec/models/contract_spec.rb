require_relative '../spec_helper'

describe 'Contract' do
  let(:contract) {build(:contract)}
  it 'should be created' do
    contract.should_not be_nil
  end

  it 'has correct associations' do
    contract.company.name.should match /Company_\d/
    contract.employee.full_name.should match /Name_\d/
    contract.job_position.name.should match /Job_\d/
  end

  it 'is unique on company-employee' do
    c = create :company
    e = create :employee
    create :contract, company: c, employee: e
    build(:contract, company: c, employee: e).should be_invalid
    lambda {create :contract, company: c, employee: e}.should raise_error
  end

  it 'has required attributes' do
    build(:contract, job_position: nil).should be_invalid
    build(:contract, company: nil).should be_invalid
    build(:contract, employee: nil).should be_invalid
  end

end