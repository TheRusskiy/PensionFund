require_relative '../feature_helper'

feature 'company page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    sign_as_admin
    @company = create :company
    @another_company = create :company
    visit'/companies'
  end

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'display all' do
    expect(page).to have_content(t 'company.title')
    expect(page).to have_content(@company.name)
    expect(page).to have_content(@company.property_type.name)
  end

  scenario 'delete from list-page' do
    click(t('company.destroy'), :href => company_path(@another_company))
    Company.exists?(@another_company).should be_false
    Company.exists?(@company).should be_true
  end

  scenario 'details should display all companies and jobs' do
    create :contract, company: @company
    create :contract, company: @company
    another_contract = create :contract

    click(t('company.show'), :href => company_path(@company))
    expect(page).to have_content(@company.name)
    expect(page).not_to have_content(@another_company.name)

    @company.contracts.each do |c|
      expect(page).to have_content(c.employee.full_name)
      expect(page).to have_content(c.job_position.name)
    end
    expect(page).not_to have_content(another_contract.employee.full_name)
  end


  scenario 'can be edited' do
    foo = create :property_type, name: 'foo property'
    create :property_type, name: 'bar property'

    click(t('company.edit'), :href => edit_company_path(@company))
    find_field(t 'company.name').value.should eq @company.name
    fill_in t('company.name'), with: 'Foo Inc.'

    select('foo property', :from => t('company.property_type'))

    click t 'company.update'
    @company.reload.name.should eq 'Foo Inc.'
    @company.property_type.should eq foo
    current_path.should eq company_path(@company)
  end

  scenario 'can be created' do
    click t('company.new'), :href => new_company_path
    fill_in t('company.name'), with: 'Bar Inc.'
    fill_in t('company.vat'), with: '6666'
    click t 'company.update'
    company = Company.last
    company.name.should eq 'Bar Inc.'
    current_path.should eq company_path(company)
  end

  scenario 'should allow creation of new contract with current company pre filled'+
           ' and current employees filtered out' do
    current_contract = create :contract, company: @company
    click(t('company.show'), :href => company_path(@company))
    click(t('company.new_contract'))
    current_path.should eq new_contract_path
    find_field(t'contract.company').find('option[selected]').text.should eq @company.name
    expect(page).not_to have_content(current_contract.employee.full_name)
  end

  scenario 'should allow creation of new employee and then redirect to contract creation' +
           ' with current company and newly created employee pre filled'+
           ' and current employees filtered out' do
    current_contract = create :contract, company: @company
    click(t('company.show'), :href => company_path(@company))
    click(t('company.new_contract'))

    fill_in t('employee.full_name'), with: 'foo_bar'
    click t('employee.update')

    current_path.should eq new_contract_path
    employee = Employee.last
    employee.full_name.should eq 'foo_bar'

    find_field(t'contract.company').find('option[selected]').text.should eq @company.name
    find_field(t'contract.employee').find('option[selected]').text.should eq employee.full_name

    expect(page).not_to have_content(current_contract.employee.full_name)
  end
end