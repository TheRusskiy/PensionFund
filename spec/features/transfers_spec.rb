require_relative '../feature_helper'

feature 'transfer page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    sign_as_admin
    @transfer = create :transfer
    @another_transfer = create :transfer
    visit'/transfers'
  end

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'display all' do
    expect(page).to have_content(t 'transfer.title')
    expect(page).to have_content(@transfer.company.name)
  end

  scenario 'delete from list-page' do
    click t('transfer.destroy'), href: transfer_path(@another_transfer)
    Transfer.exists?(@another_type).should be_false
    Transfer.exists?(@transfer).should be_true
  end

  scenario 'has link to details' do
    click t('transfer.show'), href: transfer_path(@transfer)
    expect(page).to have_content(@transfer.company.name)
    expect(page).not_to have_content(@another_transfer.company.name)
  end

  scenario 'can be edited' do
    foo = create :company, name: 'foo company'

    click t('transfer.edit'), href: edit_transfer_path(@transfer)
    find_field(t 'transfer.amount').value.should eq @transfer.amount.to_s
    fill_in t('transfer.amount'), :with => '4200'

    select('foo company', :from => t('transfer.company'))

    click t 'transfer.update'
    @transfer.reload.amount.should eq 4200
    @transfer.company.should eq foo
    current_path.should eq transfers_path
  end

  scenario 'can be created' do
    click t('transfer.new'), :href => new_transfer_path
    fill_in t('transfer.amount'), :with => '4200'
    click t 'transfer.update'
    transfer = Transfer.last
    transfer.amount.should eq 4200
    current_path.should eq transfers_path
  end

  scenario 'can filter transfers by company/year+month,'+
           ' and on edit redirect back with filter preserved' do
    c1 = create :company
    c2 = create :company
    t1 = create :transfer, month: 1, year:2011
    t2 = create :transfer, month: 2, year:2010
    t3 = create :transfer, month: 1, year:2010, company: c1
    t4 = create :transfer, month: 1, year:2010, company: c1
    t5 = create :transfer, month: 1, year:2010, company: c2

    visit '/transfers'
    expect(page).to have_content(t1.id)
    expect(page).to have_content(t2.id)
    expect(page).to have_content(t3.id)
    expect(page).to have_content(t4.id)
    expect(page).to have_content(t5.id)

    check t'transfer.company_filter'
    check t'transfer.date_filter'
    select c1.to_s, from: t('transfer.company_filter_value')
    select 2010, from: t('transfer.year_filter_value')
    select I18n.t('date.month_names')[1], from: t('transfer.month_filter_value')
    click t'transfer.apply_filter'

    click t('transfer.edit'), href: edit_transfer_path(t4)
    click t 'transfer.update'

    expect(page).not_to have_content(t1.transfer_date)
    expect(page).not_to have_content(t2.transfer_date)
    expect(page).to have_content(t3.transfer_date)
    expect(page).to have_content(t4.transfer_date)
    expect(page).not_to have_content(t5.transfer_date)
  end
end