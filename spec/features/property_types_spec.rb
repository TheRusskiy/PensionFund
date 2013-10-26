require_relative '../feature_helper'

feature 'Property type page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    sign_as_admin
    @transfer = create :property_type
    @another_transfer = create :property_type
    visit'/property_types'
  end

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'display property types' do
    expect(page).to have_content(t 'property.title')
    expect(page).to have_content(@transfer.name)
  end

  scenario 'delete property type from list-page' do
    click(t('property.destroy'), :href => property_type_path(@another_transfer))
    PropertyType.exists?(@another_transfer).should be_false
    PropertyType.exists?(@transfer).should be_true
  end

  scenario 'should have link to details' do
    click(t('property.show'), :href => property_type_path(@transfer))
    expect(page).to have_content(@transfer.name)
    expect(page).not_to have_content(@another_transfer.name)
  end

  scenario 'can be edited' do
    click(t('property.edit'), :href => edit_property_type_path(@transfer))
    find_field(t 'property.name').value.should eq @transfer.name
    fill_in t('property.name'), :with => 'FooName'
    click (t 'property.update')
    @transfer.reload.name.should eq 'FooName'
    current_path.should eq property_type_path(@transfer)
  end

  scenario 'can be created' do
    click(t('property.new'), :href => new_property_type_path)
    fill_in t('property.name'), :with => 'BarName'
    click (t 'property.update')
    property = PropertyType.last
    property.name.should eq 'BarName'
    current_path.should eq property_type_path(property)
  end
end