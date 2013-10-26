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

def sign_as_operator
  operator = create :user_operator
  visit '/'
  fill_in(t('menu.password'), with: operator.password)
  fill_in(t('menu.email'), with: operator.email)
  click_button(t 'menu.sign_in')
  operator
end

def click(css, attr_hash = {})
  elements = all(css).select do |e|
    fits = true
    attr_hash.each_pair do |key, value|
      key = key.to_s
      case key
        when 'text' then
          fits = fits && e.text=~/#{value}/
        when 'value' then
          fits = fits && e.value=~/#{value}/
        else
          fits = fits && e[key]=~/#{value}/
      end
    end
    fits
  end
  raise Exception.new "Ambiguous match: #{elements.text}" if elements.length>1
  raise Exception.new "No elements match: #{css}, #{attr_hash.to_s}" if elements.length==0
  elements.first.click
end