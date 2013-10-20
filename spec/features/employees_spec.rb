require_relative 'feature_helper'

feature 'Employee page' do
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
    expect(page).to have_content('employees')
    expect(page).to have_content(@employee.full_name)
  end

  scenario 'delete employees from list-page' do
    click_link(t('employee.destroy'), :href => employee_path(@another_employee))
    Employee.exists?(@another_employee).should be_false
    Employee.exists?(@employee).should be_true
  end

  scenario 'should have link to details' do
    click_link(t('employee.show'), :href => employee_path(@employee))
    expect(page).to have_content(@employee.full_name)
    expect(page).not_to have_content(@another_employee.full_name)
  end

  scenario 'can be edited' do
    click_link(t('employee.edit'), :href => edit_employee_path(@employee))
    find_field(t 'employee.full_name').value.should eq @employee.full_name
    fill_in t('employee.full_name'), :with => 'FooName'
    click_button(t 'employee.update')
    @employee.reload.full_name.should eq 'FooName'
  end
end