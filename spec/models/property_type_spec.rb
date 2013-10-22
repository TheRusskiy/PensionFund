require_relative '../spec_helper'

describe 'Property Type' do
  let(:type) {build(:property_type)}
  it 'should be created' do
    type.name.should be =~ /private_\d+/
  end

  it 'should have many companies' do
    type = build(:type_with_company)
    type.companies.size.should be>0
  end

  it 'must have name' do
    (build :property_type, name: '').should be_invalid
  end

  it 'has unique name' do
    p = create :property_type
    p.should be_valid
    (build :property_type, name: p.name).should be_invalid
    lambda { create :property_type, name: p.name}.should raise_error
  end

end