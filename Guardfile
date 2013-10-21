# A sample Guardfile
# More info at https://github.com/guard/guard#readme

#interactor :simple
notification :off

#guard :rspec do
#  watch(%r{^spec/.+_spec\.rb$})
#  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/lib/#{m[1]}_spec.rb" }
#  watch('spec/spec_helper.rb')  { "spec" }
#
#  # Rails example
#  watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
#  watch(%r{^app/(.*)(\.erb|\.haml|\.slim)$})          { |m| "spec/#{m[1]}#{m[2]}_spec.rb" }
#  watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { |m| ["spec/routing/#{m[1]}_routing_spec.rb", "spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb", "spec/acceptance/#{m[1]}_spec.rb"] }
#  watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
#  watch('config/routes.rb')                           { "spec/routing" }
#  watch('app/controllers/application_controller.rb')  { "spec/controllers" }
#
#  # Capybara features specs
#  watch(%r{^app/views/(.+)/.*\.(erb|haml|slim)$})     { |m| "spec/features/#{m[1]}_spec.rb" }
#
#  # Turnip features and steps
#  watch(%r{^spec/acceptance/(.+)\.feature$})
#  watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$})   { |m| Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance' }
#end

group :specs do
  guard 'spring', :rspec_cli => '--fail-fast --color' do
    watch(%r{^spec/.+_spec\.rb$})
    #watch(%r{^db/schema.rb$})                           { |m| ['rake db:test:purge', 'rake db:test:load', 'rake db:test:prepare']}
    watch(%r{^spec/factories/.+\.rb$})
    watch(%r{^spec/spec_helper\.rb$})                   { |m| 'spec' }
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    #watch(%r{^app/config/(.|\/)*$})                     { |m| "spec/features" }
    watch(%r{^app/views/(.+)$})                         { |m| "spec/features" }
    watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "spec/features/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    #watch(%r{^app/controllers/(.+)_(controller)\.rb$})  do |m|
    #  %W(spec/routing/#{m[1]}_routing_spec.rb spec/#{m[2]}s/#{m[1]}_#{m[2]}_spec.rb spec/requests/#{m[1]}_spec.rb)
    #end
  end
end
