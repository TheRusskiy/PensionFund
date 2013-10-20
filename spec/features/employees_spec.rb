require_relative 'feature_helper'

describe 'Employee page' do

  it 'should display employees' do
    #sign_in 'admin', 'pass'
    create :employee, :full_name=>'Dmitry Ishkov'
    visit '/employees'
    expect(page).to have_content('employees')
    expect(page).to have_content('Dmitry Ishkov')
  end
end