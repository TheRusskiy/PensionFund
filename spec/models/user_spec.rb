require_relative '../spec_helper'

describe 'User' do
  it 'can be created' do
    user = create :user
  end

  it "should be invalid when passwords don't match" do
    user = build :user_non_matching_passwords
    user.should_not be_valid
  end

  it "can be authenticated" do
    user = create :user
    User.find_by_email(user.email).authenticate(user.password).should be_true
    User.find_by_email(user.email).authenticate(user.password+"bar").should be_false
  end

  it "has text roles" do
    build(:user_guest).role.should eq "guest"
    build(:user_operator).role.should eq "operator"
    build(:user_admin).role.should eq "admin"
    build(:user_inspector).role.should eq "inspector"
    build(:user_manager).role.should eq "manager"
  end

end