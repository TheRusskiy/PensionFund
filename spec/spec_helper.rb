require_relative 'support/deferred_garbage_collection'

RSpec.configure do |config|
  config.before(:all) do
    DeferredGarbageCollection.start
  end

  config.after(:all) do
    DeferredGarbageCollection.reconsider
  end

  config.include FactoryGirl::Syntax::Methods
  config.before(:suite) { FactoryGirl.reload }
end