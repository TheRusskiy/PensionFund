require_relative '../feature_helper'

feature 'Users page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    sign_as_admin
    @user = create :user
    @another_user = create :user
    visit'/users'
  end

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'should display users' do
    expect(page).to have_content(t 'user.title')
    expect(page).to have_content(@user.email)
  end

  scenario 'delete users from list-page' do
    click(t('user.destroy'), :href => user_path(@another_user))
    User.exists?(@another_user).should be_false
    User.exists?(@user).should be_true
  end

  scenario 'should have link to details' do
    click(t('user.show'), :href => user_path(@user))
    expect(page).to have_content(@user.email)
    expect(page).not_to have_content(@another_user.email)
  end

  scenario 'can be edited' do
    click(t('user.edit'), :href => edit_user_path(@user))
    find_field(t 'user.email').value.should eq @user.email
    fill_in t('user.email'), :with => 'foo@example.com'
    click (t 'user.update')
    @user.reload.email.should eq 'foo@example.com'
    current_path.should eq user_path(@user)
  end

  scenario 'can be created' do
    click(t('user.new'), :href => new_user_path)
    fill_in t('user.email'), :with => 'bar@example.com'
    fill_in t('user.password'), :with => 'password'
    fill_in t('user.password_confirmation'), :with => 'password'
    click (t 'user.update')
    user = User.last
    user.email.should eq 'bar@example.com'
    current_path.should eq user_path(user)
  end
end