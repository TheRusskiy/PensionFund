require_relative 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'
#Capybara.javascript_driver = :webkit
include Capybara::DSL

def sign_as_admin
  admin = create :user_admin
  visit '/'
  fill_in(t('menu.password'), with: admin.password)
  fill_in(t('menu.email'), with: admin.email)
  click_button(t 'menu.sign_in')
  admin
end