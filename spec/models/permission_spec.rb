require_relative '../spec_helper'

RSpec::Matchers.define :permit do |resources, actions, obj = nil|
  match do |permission|
    Array(resources).each do |r|
      Array(actions).each do |a|
        permission.permit?(r, a, obj).should be_true
      end
    end
  end
end

describe 'Guest permission' do
  subject{ Permission.new nil}
  it 'should allow' do
    allowed = [:index]
    res = [:companies, :employees]
    sign_up = [:new, :create, :show]
    should permit(res, allowed)
    should permit(:home, :index)
    should permit(:application, [:authenticate, :logout])
    should permit(:users, sign_up)
    should_not permit(res, Permission.actions-allowed)
    should_not permit(Permission.resources-res-[:users], Permission.actions)
    should_not permit([:users], Permission.actions-sign_up)
  end
end

describe 'Admin permission' do
  subject{ Permission.new build(:user_admin)}
  it 'should allow' do
    should permit(Permission.resources, Permission.actions)
  end
end

describe 'Operator permission' do
  let(:user) {build(:user_operator)}
  let(:another_user) {build(:user_operator)}
  subject{ Permission.new user}
  it 'should allow' do
    allowed = Permission.actions
    res = Permission.resources - [:users]
    should permit(res, allowed)
    should permit(:home, :index)
    should permit([:users], Permission.actions-[:edit, :update, :destroy])
    should permit([:users], [:edit, :update, :destroy], user)
    should_not permit([:users], [:edit, :update, :destroy], another_user)
  end
end

describe 'Inspector permission' do
  let(:user) {build(:user_inspector)}
  let(:another_user) {build(:user_inspector)}
  subject{ Permission.new user}
  it 'should allow' do
    disallowed = [:new, :create, :edit, :update, :destroy]
    allowed = Permission.actions-disallowed
    res = Permission.resources - [:users]
    should permit(res, allowed)
    should_not permit(res, disallowed)
    should permit([:users], Permission.actions-[:edit, :update, :destroy])
    should permit([:users], [:edit, :update, :destroy], user)
    should_not permit([:users], [:edit, :update, :destroy], another_user)
  end
end

describe 'Manager permission' do
  let(:user) {build(:user_manager)}
  let(:another_user) {build(:user_manager)}
  subject{ Permission.new user}
  it 'should allow' do
    disallowed = [:new, :create, :edit, :update, :destroy]
    allowed = Permission.actions-disallowed
    res = Permission.resources - [:users]
    should permit(res, allowed)
    should_not permit(res, disallowed)
    should permit([:users], Permission.actions-[:edit, :update, :destroy])
    should permit([:users], [:edit, :update, :destroy], user)
    should_not permit([:users], [:edit, :update, :destroy], another_user)
  end
end
