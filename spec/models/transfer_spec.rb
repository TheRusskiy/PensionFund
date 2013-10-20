require_relative '../spec_helper'

describe 'Transfer' do
  let(:transfer) {build(:transfer)}
  it 'should be created' do
    transfer.amount.should eq(1000)
  end

  it 'has company' do
    transfer.company.vat.should be >= 0
  end
end