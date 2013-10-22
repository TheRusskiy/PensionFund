require_relative 'spec_helper'
require 'capybara/rails'
require 'capybara/rspec'
Capybara.javascript_driver = :webkit
include Capybara::DSL