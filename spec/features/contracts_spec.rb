require_relative '../feature_helper'

feature 'Contract page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    #sign_in 'admin', 'pass'
    @contract = create :contract
    @another_contract = create :contract
    visit'/contracts'
  end

  after(:each) do
    save_and_open_page if example.exception
  end

  scenario 'display all' do
    expect(page).to have_content(t 'contract.title')
    expect(page).to have_content(@contract.employee.full_name)
  end

  scenario 'delete from list-page' do
    click_link(t('contract.destroy'), :href => contract_path(@another_contract))
    Contract.exists?(@another_contract).should be_false
    Contract.exists?(@contract).should be_true
  end

  scenario 'has link to details' do
    click_link(t('contract.show'), :href => contract_path(@contract))
    expect(page).to have_content(@contract.company.name)
    expect(page).not_to have_content(@another_contract.company.name)
  end

  scenario 'can be edited' do
    some_employee = create :employee
    some_company = create :company
    some_position = create :job_position

    click_link(t('contract.edit'), :href => edit_contract_path(@contract))
    find_field(t 'contract.company').value.should eq @contract.company.id.to_s

    select(some_company.name, :from => t('contract.company'))
    select(some_position.name, :from => t('contract.job_position'))
    select(some_employee.full_name, :from => t('contract.employee'))

    click_button(t 'contract.update')
    @contract.reload.company.should eq some_company
    @contract.job_position.should eq some_position
    @contract.employee.should eq some_employee
    current_path.should eq contract_path(@contract)
  end

  scenario 'can be created' do
    some_employee = create :employee
    some_company = create :company
    some_position = create :job_position

    click_link(t('contract.new'), :href => new_contract_path)
    select(some_company.name, :from => t('contract.company'))
    select(some_position.name, :from => t('contract.job_position'))
    select(some_employee.full_name, :from => t('contract.employee'))
    click_button(t 'contract.update')

    contract = Contract.last
    contract.company.should eq some_company
    current_path.should eq contract_path(contract)
  end
end