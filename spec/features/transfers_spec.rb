require_relative '../feature_helper'

feature 'transfer page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    #sign_in 'admin', 'pass'
    @transfer = create :transfer
    @another_transfer = create :transfer
    visit'/transfers'
  end

  after(:each) do
    save_and_open_page if example.exception
  end

  scenario 'display all' do
    expect(page).to have_content(t 'transfer.title')
    expect(page).to have_content(@transfer.company.name)
  end

  scenario 'delete from list-page' do
    click_link(t('transfer.destroy'), :href => transfer_path(@another_transfer))
    Transfer.exists?(@another_type).should be_false
    Transfer.exists?(@transfer).should be_true
  end

  scenario 'has link to details' do
    click_link(t('transfer.show'), :href => transfer_path(@transfer))
    expect(page).to have_content(@transfer.company.name)
    expect(page).not_to have_content(@another_transfer.company.name)
  end

  scenario 'can be edited' do
    foo = create :company, name: 'foo company'

    click_link(t('transfer.edit'), :href => edit_transfer_path(@transfer))
    find_field(t 'transfer.amount').value.should eq @transfer.amount.to_s
    fill_in t('transfer.amount'), :with => '4200'

    select('foo company', :from => t('transfer.company'))

    click_button(t 'transfer.update')
    @transfer.reload.amount.should eq 4200
    @transfer.company.should eq foo
    current_path.should eq transfer_path(@transfer)
  end

  scenario 'can be created' do
    click_link(t('transfer.new'), :href => new_transfer_path)
    fill_in t('transfer.amount'), :with => '4200'
    click_button(t 'transfer.update')
    transfer = Transfer.last
    transfer.amount.should eq 4200
    current_path.should eq transfer_path(transfer)
  end
end