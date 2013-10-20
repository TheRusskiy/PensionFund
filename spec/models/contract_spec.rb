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

end