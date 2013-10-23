require_relative '../feature_helper'

feature 'Authentication', :slow do
  include Rails.application.routes.url_helpers

  #before(:each) do
    #sign_in 'admin', 'pass'
    #visit '/'
  #end

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'should be able to sign in' do
    admin = create :user_admin
    visit '/'
    expect(page).to have_content(t 'user.guest')
    expect(page).not_to have_content(admin.email)
    fill_in(t('menu.password'), with: admin.password)
    fill_in(t('menu.email'), with: admin.email)

    click_button(t 'menu.sign_in')
    current_path.should eq root_path
  end

  scenario 'log out' do
    admin = sign_as_admin
    expect(page).not_to have_content(t 'user.guest')
    click_button(t 'menu.log_out')
    expect(page).to have_content(t 'user.guest')
    expect(page).not_to have_content(admin.email)
  end

  scenario 'sign up' do
    visit '/'
    click_button(t 'menu.sign_up')
    current_path.should eq new_user_path
  end
end