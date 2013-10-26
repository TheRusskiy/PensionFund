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
    current_path.should eq payment_path(@payment)
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
    current_path.should eq payment_path(payment)
  end
end