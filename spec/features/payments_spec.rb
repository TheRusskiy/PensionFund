require_relative '../feature_helper'

feature 'Payments page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    #sign_in 'admin', 'pass'
    @payment = create :payment
    @another_payment = create :payment
    visit'/payments'
  end

  after(:each) do
    save_and_open_page if example.exception
  end

  scenario 'display all' do
    expect(page).to have_content(t 'payment.title')
    expect(page).to have_content(@payment.company.name)
  end

  scenario 'delete from list-page' do
    click_link(t('payment.destroy'), :href => payment_path(@another_payment))
    Payment.exists?(@another_payment).should be_false
    Payment.exists?(@payment).should be_true
  end

  scenario 'has link to details' do
    click_link(t('payment.show'), :href => payment_path(@payment))
    expect(page).to have_content(@payment.company.name)
    expect(page).not_to have_content(@another_payment.company.name)
  end

  scenario 'can be edited' do
    some_employee = create :employee
    some_company = create :company

    click_link(t('payment.edit'), :href => edit_payment_path(@payment))
    find_field(t 'payment.amount').value.should eq @payment.amount.to_s
    fill_in t('payment.amount'), :with => '4200'

    select(some_company.name, :from => t('payment.company'))
    select(some_employee.full_name, :from => t('payment.employee'))

    click_button(t 'payment.update')
    @payment.reload.amount.should eq 4200
    @payment.company.should eq some_company
    @payment.employee.should eq some_employee
    current_path.should eq payment_path(@payment)
  end

  scenario 'can be created' do
    click_link(t('payment.new'), :href => new_payment_path)
    fill_in t('payment.amount'), :with => '4200'
    fill_in t('payment.year'), :with => '2000'
    fill_in t('payment.month'), :with => '12'
    click_button(t 'payment.update')
    payment = Payment.last
    payment.amount.should eq 4200
    current_path.should eq payment_path(payment)
  end
end