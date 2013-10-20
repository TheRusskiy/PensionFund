require 'rspec'
require_relative '../spec_helper'

describe 'Property Type' do
  let(:type) {build(:property_type)}
  it 'should be created' do
    type.name.should eq("private")
  end

  it 'should have many companies' do
    type = build(:type_with_company)
    type.companies.size.should be>0
  end
end