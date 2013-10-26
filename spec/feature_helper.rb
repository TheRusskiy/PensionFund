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

def click(value, attr_hash = {}, css = nil)
  elements = css ? all(css) : Array(all('a'))+Array(all('input'))
  elements = elements.select do |e|
    fits = e.text=~/#{value}/ || e.value=~/#{value}/
    attr_hash.each_pair do |attr, attr_value|
      fits = fits && e[attr.to_s]=~/#{attr_value}/
    end
    fits
  end
  raise Exception.new "Ambiguous match: \n#{prettify elements}" if elements.length>1
  raise Exception.new 'No elements match:'+
                      " #{css.nil? ? 'link/input' : "css '#{css}'"}"+
                      " with value '#{value}' and params #{attr_hash.to_s}" if elements.length==0
  elements.first.click
end

private
def prettify elements
  i=0
  formatted = elements.map do |e|
    # very brittle to changes... but pretty :-)
    i+=1
    i.to_s+': '+e.base.send(:string_node).native.to_s
  end
  formatted * "\n"
end
