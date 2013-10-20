require 'factory_girl'
Spring.after_fork do
  FactoryGirl.factories.clear
end
