FactoryGirl.define do
  factory :company do
    sequence(:name) {|n| "Company_#{n}"}
    sequence(:vat) {|n| n }
  end
end