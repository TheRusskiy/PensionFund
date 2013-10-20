require 'rspec'

describe 'Company' do
  let(:company) {build(:company)}
  it 'should be created' do
    company.name.should match /Company_\d/
  end
end