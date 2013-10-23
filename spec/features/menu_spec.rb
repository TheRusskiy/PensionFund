require_relative '../feature_helper'

feature 'Top bar menu', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    sign_as_admin
    visit '/'
  end

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'should contain links to other pages' do
    click_link(t 'menu.employees')
    current_path.should eq employees_path

    click_link(t 'menu.companies')
    current_path.should eq companies_path

    click_link(t 'menu.users')
    current_path.should eq users_path
  end
end