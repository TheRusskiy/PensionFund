#!/usr/bin/env ruby

# Suppress zeus' whining about how it won't use your RAILS_ENV
#ENV.delete('RAILS_ENV')

# Zeus 0.13.2 parses options badly. RubyMine will invoke this file like this:
# rspec_runner.rb spec/my_cool_file.rb --require teamcity/spec/runner/formatter/teamcity/formatter --format Spec::Runner::Formatter::TeamcityFormatter
#
# ...but Zeus will parse those options thinking --require is meant for it, and die.
# If the test file is moved to the end, it dies less.
#ARGV.push(ARGV.shift)

# Add rspec to the beginning of the commands sent to Zeus
#ARGV.push(ARGV.shift)
#ARGV.push(ARGV.shift) unless ARGV[-1].match(/\.rb$/)
ARGV.unshift 'rspec'

a0 = "rspec"
a1 = "--require"
a2 = "teamcity/spec/runner/formatter/teamcity/formatter"
a3 = "--format"
a4 = "Spec::Runner::Formatter::TeamcityFormatter"
a5 = "--backtrace"
specs = ARGV.select {|file| file=~ /\.rb$/}
specs.map! do |file|
  root = Dir.pwd
  #file.slice! root
  '.'+file.gsub(root, '')
end

ARGV = [a0, a1, a2, a3, a4]+specs#, a6, a7, a8]
require 'rubygems'
require 'zeus'
load Gem.bin_path('zeus', 'zeus')
#unexpected token at '"/home/therusskiy/ruby/pensionfund/spec/' (JSON::ParserError)