require_relative '../spec_helper'
require "#{Rails.root}/lib/queries"

describe 'Queries', :slow do
  before(:each) do
    Employee.count.should eq 0
    Payment.count.should eq 0
  end

  it "Inspector query: \ncount number of employees from certain company with average"+
    " salary bigger than certain amount over some period of time" do
    c1 = create :company
    c2 = create :company
    e1 = create :employee
    e2 = create :employee
    e3 = create :employee
    e4 = create :employee
    e5 = create :employee

    average = 300
    # average = 200, doesn't fit
    create :payment, amount: 100, year:2000, month:1, employee:e1, company: c1
    create :payment, amount: 200, year:2000, month:2, employee:e1, company: c1
    create :payment, amount: 300, year:2000, month:3, employee:e1, company: c1

    # average = 300, fits
    create :payment, amount: 100, year:2000, month:1, employee:e2, company: c1
    create :payment, amount: 100, year:2000, month:2, employee:e2, company: c1
    create :payment, amount: 700, year:2000, month:3, employee:e2, company: c1

    # average = 400, fits
    create :payment, amount: 100, year:2000, month:1, employee:e3, company: c1
    create :payment, amount: 100, year:2000, month:2, employee:e3, company: c1
    create :payment, amount: 1000, year:2000, month:3, employee:e3, company: c1

    # average = 400, wrong company
    create :payment, amount: 100, year:2000, month:1, employee:e4, company: c2
    create :payment, amount: 100, year:2000, month:2, employee:e4, company: c2
    create :payment, amount: 1000, year:2000, month:3, employee:e4, company: c2

    # average = 100, doesn't fit
    create :payment, amount: 9999, year:1999, month:1, employee:e5, company: c1
    create :payment, amount: 100, year:2000, month:2, employee:e5, company: c1
    create :payment, amount: 9999, year:2000, month:4, employee:e5, company: c1

    result = Queries::inspector_query(c1, average, 2000, 1, 2000, 3)
    result.size.should eq 2
    result.should_not include e1
    result.should include e2
    result.should include e3
    result.should_not include e4
    result.should_not include e5
  end

  it "Manager query: \n"+
     "average monthly salaries for companies in selected year "+
     "grouped by company and month" do
    c1 = create :company
    c2 = create :company
    e1 = create :employee
    e2 = create :employee
    e3 = create :employee
    create :payment, amount: 666, year:1999, month:1, employee:e1, company: c1 # wrong year

    create :payment, amount: 103, year:2000, month:1, employee:e1, company: c1
    create :payment, amount: 200, year:2000, month:1, employee:e2, company: c1
    create :payment, amount: 300, year:2000, month:1, employee:e3, company: c1

    create :payment, amount: 333, year:2000, month:2, employee:e3, company: c1

    create :payment, amount: 444, year:2000, month:1, employee:e3, company: c2

    result = Queries::manager_query(2000)
    result.sort! {|r1, r2| r1['amount'] <=> r2['amount'] }

    result.length.should eq 3

    result[0]['amount'].should eq 201
    result[1]['amount'].should eq 333
    result[2]['amount'].should eq 444

    result[0]['company'].should eq c1
    result[1]['month'].should eq 2
  end
end