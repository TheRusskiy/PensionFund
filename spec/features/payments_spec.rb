require_relative '../feature_helper'

feature 'Payments page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    sign_as_admin
    @payment = create :payment
    @another_payment = create :payment
    visit'/payments'
  end

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'display all' do
    expect(page).to have_content(t 'payment.title')
    expect(page).to have_content(@payment.company.name)
  end

  scenario 'delete from list-page' do
    click(t('payment.destroy'), :href => payment_path(@another_payment))
    Payment.exists?(@another_payment).should be_false
    Payment.exists?(@payment).should be_true
  end

  scenario 'has link to details' do
    click(t('payment.show'), :href => payment_path(@payment))
    expect(page).to have_content(@payment.company.name)
    expect(page).not_to have_content(@another_payment.company.name)
  end

  scenario 'can be edited' do
    some_employee = create :employee
    some_company = create :company

    click(t('payment.edit'), :href => edit_payment_path(@payment))
    find_field(t 'payment.amount').value.should eq @payment.amount.to_s
    fill_in t('payment.amount'), :with => '4200'

    select(some_company.name, :from => t('payment.company'))
    select(some_employee.full_name, :from => t('payment.employee'))

    click (t 'payment.update')
    @payment.reload.amount.should eq 4200
    @payment.company.should eq some_company
    @payment.employee.should eq some_employee
    current_path.should eq payments_path
  end

  scenario 'can be created' do
    click(t('payment.new'), :href => new_payment_path)
    fill_in t('payment.amount'), :with => '4200'
    select '2012', :from => t('payment.year')
    select I18n.t('date.month_names')[1], :from => t('payment.month')
    click (t 'payment.update')
    payment = Payment.last
    payment.amount.should eq 4200
    payment.year.should eq 2012
    current_path.should eq payments_path
  end

  scenario 'can filter payments by company/year+month/employee,'+
           ' and on edit redirect back with filter preserved' do
    c1 = create :company
    c2 = create :company
    e1 = create :employee
    e2 = create :employee
    t1 = create :payment, month: 1, year:2011
    t2 = create :payment, month: 2, year:2010
    t3 = create :payment, month: 1, year:2010, company: c1, employee: e1
    t4 = create :payment, month: 2, year:2010, company: c1, employee: e1
    t5 = create :payment, month: 1, year:2010, company: c2, employee: e1
    t6 = create :payment, month: 1, year:2010, company: c1, employee: e2

    visit '/payments'
    expect(page).to have_content(t1.amount)
    expect(page).to have_content(t2.amount)
    expect(page).to have_content(t3.amount)
    expect(page).to have_content(t4.amount)
    expect(page).to have_content(t5.amount)
    expect(page).to have_content(t6.amount)

    check t'payment.company_filter'
    check t'payment.employee_filter'
    uncheck t'payment.date_filter'
    select c1.to_s, from: t('payment.company_filter_value')
    select e1.to_s, from: t('payment.employee_filter_value')
    click t'payment.apply_filter'

    click t('payment.edit'), href: edit_payment_path(t4)
    click t 'payment.update'

    expect(page).not_to have_content(t1.amount)
    expect(page).not_to have_content(t2.amount)
    expect(page).to have_content(t3.amount)
    expect(page).to have_content(t4.amount)
    expect(page).not_to have_content(t5.amount)
    expect(page).not_to have_content(t6.amount)
  end
end