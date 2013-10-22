require_relative '../spec_helper'

describe 'Company' do
  let(:company) {build(:company)}
  it 'should be created' do
    company.name.should match /Company_\d/
  end

  it 'has property type' do
    company.property_type = build :property_type
  end

  it 'has many employees and contracts' do
    company_with_employees = create(:companies_with_employees)
    company_with_employees.employees.size.should be > 0

    company_with_employees.contracts.size.should be > 0
  end

  it 'has many transfers' do
    company = create(:companies_with_transfers)
    company.transfers.size.should be > 0
    company.transfers[0].company.should eq company
  end

  it 'has unique VAT and name' do
    c = create :company
    build(:company, vat: c.vat).should be_invalid
    lambda {create :company, vat: c.vat}.should raise_error
    build(:company, name: c.name).should be_invalid
    lambda {create :company, name: c.name}.should raise_error
  end

  it 'has required attributes' do
    build(:company, name: nil).should be_invalid
    build(:company, vat: nil).should be_invalid
    build(:company, property_type: nil).should be_invalid
  end
end