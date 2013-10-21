require_relative 'feature_helper'

feature 'company page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    #sign_in 'admin', 'pass'
    @company = create :company
    @another_company = create :company
    visit'/companies'
  end

  after(:each) do
    save_and_open_page if example.exception
  end

  scenario 'display all' do
    expect(page).to have_content(t 'company.title')
    expect(page).to have_content(@company.name)
    expect(page).to have_content(@company.property_type.name)
  end

  scenario 'delete from list-page' do
    click_link(t('company.destroy'), :href => company_path(@another_company))
    Company.exists?(@another_company).should be_false
    Company.exists?(@company).should be_true
  end

  scenario 'has link to details' do
    click_link(t('company.show'), :href => company_path(@company))
    expect(page).to have_content(@company.name)
    expect(page).not_to have_content(@another_company.name)
  end

  scenario 'can be edited' do
    foo = create :property_type, name: 'foo property'
    create :property_type, name: 'bar property'

    click_link(t('company.edit'), :href => edit_company_path(@company))
    find_field(t 'company.name').value.should eq @company.name
    fill_in t('company.name'), :with => 'Foo Inc.'

    select('foo property', :from => t('company.property_type'))

    click_button(t 'company.update')
    @company.reload.name.should eq 'Foo Inc.'
    @company.property_type.should eq foo
    current_path.should eq company_path(@company)
  end

  scenario 'can be created' do
    click_link(t('company.new'), :href => new_company_path)
    fill_in t('company.name'), :with => 'Bar Inc.'
    click_button(t 'company.update')
    company = Company.last
    company.name.should eq 'Bar Inc.'
    current_path.should eq company_path(company)
  end
end