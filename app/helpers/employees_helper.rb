module EmployeesHelper
  def employee_items employees=Employee.all
    employees.map{|e|
      [e.full_name, e.id]
    }.sort!{|e1,e2|
      e1[0]<=>e2[0]
    }
  end

  def employees_not_from_company company
    return Employee.all if company.nil?
    Employee.all-company.employees
  end
end
