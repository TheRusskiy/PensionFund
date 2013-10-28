require_relative '../feature_helper'

feature 'Queries page', :slow do
  include Rails.application.routes.url_helpers

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'for inspector' do
    c1 = create :company
    c2 = create :company
    e1 = create :employee
    e2 = create :employee
    e3 = create :employee

    # average = 500, fits
    create :payment, amount: 100, year:2010, month:2, employee:e1, company: c1
    create :payment, amount: 900, year:2010, month:3, employee:e1, company: c1

    # average = 1000, but wrong company
    create :payment, amount: 1000, year:2010, month:1, employee:e2, company: c2

    # average = 100, because wrong year
    create :payment, amount: 9999, year:2009, month:1, employee:e3, company: c1
    create :payment, amount: 100, year:2010, month:2, employee:e3, company: c1

    sign_as_inspector
    visit'/queries/inspector'

    expect(page).to have_content(t 'query.title')

    fill_in t('query.inspector.average'), with: '500'
    select '2010', from: t('query.inspector.from_year')
    select '2010', from: t('query.inspector.to_year')
    select I18n.t('date.month_names')[1], from: t('query.inspector.from_month')
    select I18n.t('date.month_names')[3], from: t('query.inspector.to_month')
    select c1.to_s, from: t('query.inspector.company')

    click t'query.inspector.submit'

    expect(page).to have_content(e1.to_s)
    expect(page).not_to have_content(e2.to_s)
    expect(page).not_to have_content(e3.to_s)
  end

  scenario 'for manager' do
    c1 = create :company
    e1 = create :employee
    e2 = create :employee
    e3 = create :employee
    create :payment, amount: 666, year:1999, month:1, employee:e1, company: c1 # wrong year

    create :payment, amount: 101, year:2010, month:1, employee:e1, company: c1
    create :payment, amount: 201, year:2010, month:1, employee:e2, company: c1

    create :payment, amount: 350, year:2010, month:2, employee:e3, company: c1

    sign_as_manager
    visit'/queries/manager'

    expect(page).to have_content(t 'query.title')

    select '2010', from: t('query.manager.year')

    click t'query.manager.submit'

    expect(page).to have_content('350')
    expect(page).to have_content('151')
    expect(page).not_to have_content('666')
  end


end