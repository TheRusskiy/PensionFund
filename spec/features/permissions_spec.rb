require_relative '../feature_helper'

feature 'Permission for operator', :slow do
  include Rails.application.routes.url_helpers
  before(:each) do
    @user = sign_as_operator
  end

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'should authorize user list' do
    expect(page).not_to have_content(t 'not_authorized')
    expect(page).to have_content(@user.email)
  end

  scenario 'should authorize to edit own profile' do
    visit edit_user_path(@user)
    expect(page).not_to have_content(t 'not_authorized')
  end

  scenario 'should not authorize to edit other user profiles' do
    @another_user = create :user
    visit edit_user_path(@another_user)
    expect(page).to have_content(t 'not_authorized')
  end

end