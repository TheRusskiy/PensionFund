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

RSpec::Matchers.define :forbid do |resources, actions, obj = nil|
  match do |permission|
    Array(resources).each do |r|
      Array(actions).each do |a|
        permission.permit?(r, a, obj).should be_false
      end
    end
  end
end

RSpec::Matchers.define :permit_parameters do |resources, parameter|
  match do |permission|
    Array(resources).each do |r|
      Array(parameter).each do |a|
        permission.permit_parameters?(r, a).should be_true
      end
    end
  end
  end

RSpec::Matchers.define :forbid_parameters do |resources, parameter|
  match do |permission|
    Array(resources).each do |r|
      Array(parameter).each do |a|
        permission.permit_parameters?(r, a).should be_false
      end
    end
  end
end

describe 'Guest' do
  subject{ Permission.new nil}
  it 'should have following permissions' do
    allowed = [:index, :show]
    res = [:companies, :employees]
    #sign_up = []
    should permit(res, allowed)
    should permit(:home, :index)
    should permit(:application, [:authenticate, :logout])

    should forbid(res, Permission.actions-allowed)
    should forbid(Permission.resources-res, Permission.actions)
  end
end

describe 'Admin' do
  subject{ Permission.new build(:user_admin)}
  it 'should have following permissions' do
    should permit(Permission.resources, Permission.actions)
  end
  it 'should be able to change his role' do
    should permit_parameters([:user], [:email, :password, :role_id])
  end
end

describe 'Operator' do
  let(:user) {build(:user_operator)}
  let(:another_user) {build(:user_operator)}
  subject{ Permission.new user}
  it 'should have following permissions' do
    allowed = Permission.actions
    res = Permission.resources - [:users]
    should permit(res, allowed)
    should permit(:home, :index)
    user_permissions = [:index, :show]
    should permit([:users], user_permissions)
    should forbid([:users], [:new, :create])
    should permit([:users], user_permissions+[:edit, :update], user)
    should_not permit([:users], [:destroy], user)
    should_not permit([:users], [:edit, :update, :destroy], another_user)
  end
  it 'should not be able to change his role' do
    should permit_parameters([:user], [:email, :password])
    should forbid_parameters([:user], [:role_id])
  end
end

describe 'Inspector' do
  let(:user) {build(:user_inspector)}
  let(:another_user) {build(:user_inspector)}
  subject{ Permission.new user}
  it 'should have following permissions' do
    disallowed = [:new, :create, :edit, :update, :destroy]
    allowed = Permission.actions-disallowed
    res = Permission.resources - [:users]
    should permit(res, allowed)
    should_not permit(res, disallowed)
    user_permissions = [:index, :show]
    should permit([:users], user_permissions)
    should forbid([:users], [:new, :create])
    should permit([:users], user_permissions+[:edit, :update], user)
    should_not permit([:users], [:destroy], user)
    should_not permit([:users], [:edit, :update, :destroy], another_user)
  end
  it 'should not be able to change his role' do
    should permit_parameters([:user], [:email, :password])
    should forbid_parameters([:user], [:role_id])
  end
end

describe 'Manager' do
  let(:user) {build(:user_manager)}
  let(:another_user) {build(:user_manager)}
  subject{ Permission.new user}
  it 'should have following permissions' do
    disallowed = [:new, :create, :edit, :update, :destroy]
    allowed = Permission.actions-disallowed
    res = Permission.resources - [:users]
    should permit(res, allowed)
    should_not permit(res, disallowed)
    user_permissions = [:index, :show]
    should permit([:users], user_permissions)
    should forbid([:users], [:new, :create])
    should permit([:users], user_permissions+[:edit, :update], user)
    should_not permit([:users], [:destroy], user)
    should_not permit([:users], [:edit, :update, :destroy], another_user)
  end
  it 'should not be able to change his role' do
    should permit_parameters([:user], [:email, :password])
    should forbid_parameters([:user], [:role_id])
  end
end
