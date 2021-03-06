require_relative '../feature_helper'

feature 'Position type page', :slow do
  include Rails.application.routes.url_helpers

  before(:each) do
    sign_as_admin
    @position = create :job_position
    @another_position = create :job_position
    visit'/job_positions'
  end

  after(:each) do
    if example.exception and not $page_opened
      save_and_open_page
      $page_opened = true
    end
  end

  scenario 'display property types' do
    expect(page).to have_content(t 'position.title')
    expect(page).to have_content(@position.name)
  end

  scenario 'delete property type from list-page' do
    click(t('position.destroy'), :href => job_position_path(@another_position))
    JobPosition.exists?(@another_position).should be_false
    JobPosition.exists?(@position).should be_true
  end

  scenario 'should have link to details' do
    click(t('position.show'), :href => job_position_path(@position))
    expect(page).to have_content(@position.name)
    expect(page).not_to have_content(@another_position.name)
  end

  scenario 'can be edited' do
    click(t('position.edit'), :href => edit_job_position_path(@position))
    find_field(t 'position.name').value.should eq @position.name
    fill_in t('position.name'), :with => 'FooName'
    click (t 'position.update')
    @position.reload.name.should eq 'FooName'
    current_path.should eq job_position_path(@position)
  end

  scenario 'can be created' do
    click(t('position.new'), :href => new_job_position_path)
    fill_in t('position.name'), :with => 'BarName'
    click (t 'position.update')
    position = JobPosition.last
    position.name.should eq 'BarName'
    current_path.should eq job_position_path(position)
  end
end