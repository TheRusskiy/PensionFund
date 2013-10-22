require_relative '../feature_helper'

feature 'Employee page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    #sign_in 'admin', 'pass'
    @employee = create :employee
    @another_employee = create :employee
    visit'/employees'
  end

  after(:each) do
    save_and_open_page if example.exception
  end

  scenario 'display employees' do
    expect(page).to have_content(t'employee.title')
    expect(page).to have_content(@employee.full_name)
  end

  scenario 'delete employees from list-page' do
    click_link(t('employee.destroy'), :href => employee_path(@another_employee))
    Employee.exists?(@another_employee).should be_false
    Employee.exists?(@employee).should be_true
  end

  scenario 'details should display all companies and jobs' do
    create :contract, employee: @employee
    create :contract, employee: @employee
    another_contract = create :contract

    click_link(t('employee.show'), :href => employee_path(@employee))
    expect(page).to have_content(@employee.full_name)
    expect(page).not_to have_content(@another_employee.full_name)

    @employee.contracts.each do |c|
      expect(page).to have_content(c.company.name)
      expect(page).to have_content(c.job_position.name)
    end
    expect(page).not_to have_content(another_contract.company.name)
  end

  scenario 'should allow creation of new contract with current employee pre filled'+
            ' and current companies filtered out' do
    current_contract = create :contract, employee: @employee
    click_link(t('employee.show'), :href => employee_path(@employee))
    click_link(t('employee.new_contract'))
    current_path.should eq new_contract_path
    find_field(t'contract.employee').find('option[selected]').text.should eq @employee.full_name
    expect(page).not_to have_content(current_contract.company.name)
  end

  scenario 'can be edited' do
    click_link(t('employee.edit'), :href => edit_employee_path(@employee))
    find_field(t 'employee.full_name').value.should eq @employee.full_name
    fill_in t('employee.full_name'), :with => 'FooName'
    click_button(t 'employee.update')
    @employee.reload.full_name.should eq 'FooName'
    current_path.should eq employee_path(@employee)
  end

  scenario 'can be created' do
    click_link(t('employee.new'), :href => new_employee_path)
    fill_in t('employee.full_name'), :with => 'BarName'
    click_button(t 'employee.update')
    employee = Employee.last
    employee.full_name.should eq 'BarName'
    current_path.should eq employee_path(employee)
  end
end