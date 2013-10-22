FactoryGirl.define do
# USERS
  factory :user do
    sequence(:email) {|n| "user_#{n}@example.com" }
    password '1234'
    password_confirmation '1234'
    role_id 0

    factory :user_non_matching_passwords do
      password_confirmation '4321'
    end

    factory(:user_guest) {role_id 0}
    factory(:user_admin) {role_id 1}
    factory(:user_operator) {role_id 2}
    factory(:user_inspector) {role_id 3}
    factory(:user_manager) {role_id 4}
  end

# PROPERTY TYPES
  factory :property_type, class: PropertyType do
    sequence(:name) {|n| "private_#{n}"}

    factory :type_with_company do
      after(:build) do |property, evaluator|
        create_list(:company, 1, property_type: property)
      end
    end
  end

# COMPANIES
  factory :company do
    sequence(:name) {|n| "Company_#{n}"}
    sequence(:vat) {|n| n }
    association :property_type, factory: :property_type, strategy: :create

    factory :companies_with_employees do
      after(:build) do |company, evaluator|
        create_list(:contract, 1, company: company)
      end
    end

    factory :companies_with_transfers do
      after(:build) do |company, evaluator|
        create_list(:transfer, 1, company: company)
      end
    end
  end

# TRANSFERS
  factory :transfer do
    amount 1000
    association :company, factory: :company, strategy: :build
    transfer_date DateTime.now
  end

# EMPLOYEES
  factory :employee do
    sequence(:full_name) {|n| "Name_#{n}"}

    factory :employee_with_payments do
      ignore do
        count 1
      end

      after(:build) do |employee, evaluator|
        create_list(:payment, evaluator.count, employee: employee)
      end
    end

    factory :employee_with_companies do
      after(:build) do |employee, evaluator|
        create_list(:contract, 1, employee: employee)
      end
    end
  end

# JOB POSITIONS
  factory :job_position do
    sequence(:name) {|n| "Job_#{n}"}
  end

# CONTRACTS
  factory :contract do
    association :company, factory: :company, strategy: :build
    association :employee, factory: :employee, strategy: :build
    association :job_position, factory: :job_position, strategy: :build
  end

# PAYMENTS
  factory :payment do
    association :company, factory: :company, strategy: :create
    association :employee, factory: :employee, strategy: :create
    sequence(:year) {|n| n+2000}
    month{rand(12)+1}
    amount 1000
  end

end