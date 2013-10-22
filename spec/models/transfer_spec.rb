require_relative '../spec_helper'

describe 'Transfer' do
  let(:transfer) {build(:transfer)}
  it 'should be created' do
    transfer.amount.should be > 0
  end

  it 'has company' do
    transfer.company.vat.should be >= 0
  end

  it 'must have company, date, amount' do
    build(:transfer, company: nil).should be_invalid
    build(:transfer, transfer_date: nil).should be_invalid
    build(:transfer, amount: nil).should be_invalid
    #wrong data format:
    build(:transfer, month: 13).should be_invalid
    build(:transfer, year: -1).should be_invalid
  end
end