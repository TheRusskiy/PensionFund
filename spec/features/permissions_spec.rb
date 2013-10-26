require_relative '../feature_helper'

feature 'Permissions for operator', :slow do
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

  scenario 'should not be able to set role_id' do
    visit edit_user_path(@user)
    select(t('user.admin'), :from => t('user.role'))
    click (t 'user.update')
    @user.reload.role.should eq t('user.operator')
  end
end

feature 'Permissions for admin', :slow do
  include Rails.application.routes.url_helpers
  before(:each) do
    @user = sign_as_admin
  end

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'should be able to set role_id' do
    visit edit_user_path(@user)
    select(t('user.operator'), :from => t('user.role'))
    click (t 'user.update')
    @user.reload.role.should eq t('user.operator')
  end

end