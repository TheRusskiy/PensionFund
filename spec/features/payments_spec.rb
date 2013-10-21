require_relative 'feature_helper'

feature 'Payments page' do
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
    click_link(t('payment.edit'), :href => edit_payment_path(@payment))
    find_field(t 'payment.amount').value.should eq @payment.amount.to_s
    fill_in t('payment.amount'), :with => '4200'
    click_button(t 'payment.update')
    @payment.reload.amount.should eq 4200
    current_path.should eq payment_path(@payment)
  end

  scenario 'can be created' do
    click_link(t('payment.new'), :href => new_payment_path)
    fill_in t('payment.amount'), :with => '4200'
    click_button(t 'payment.update')
    payment = Payment.last
    payment.amount.should eq 4200
    current_path.should eq payment_path(payment)
  end
end