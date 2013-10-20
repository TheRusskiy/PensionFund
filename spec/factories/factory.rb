FactoryGirl.define do
  factory :property_type, class: PropertyType do
    name "private"

    factory :type_with_company do
      companies {[create(:company)]}
    end
  end

  factory :company do
    sequence(:name) {|n| "Company_#{n}"}
    sequence(:vat) {|n| n }

    factory :companies_with_employees do
      employees {[create(:employee)]}
    end

    factory :companies_with_transfers do
      transfers {[create(:transfer)]}
    end
  end

  factory :transfer do
    amount 1000
    association :company, factory: :company, strategy: :build
  end

  factory :employee do
    sequence(:full_name) {|n| "Name_#{n}"}

    factory :employee_with_payments do
      ignore do
        count 3
      end

      after(:create) do |employee, evaluator|
        create_list(:payment, evaluator.count, employee: employee)
      end
    end

    factory :employee_with_companies do
      companies {[create(:company)]}
    end
  end

  factory :job_position do
    sequence(:name) {|n| "Job_#{n}"}
  end

  factory :contract do
    association :company, factory: :company, strategy: :build
    association :employee, factory: :employee, strategy: :build
    association :job_position, factory: :job_position, strategy: :build
  end

  factory :payment do
    association :company, factory: :company, strategy: :build
    association :employee, factory: :employee, strategy: :build
    amount 1000
  end

end