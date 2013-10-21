module EmployeesHelper
  def employee_items
    Employee.all.map{|e|
      [e.full_name, e.id]
    }.sort!{|e1,e2|
      e1[0]<=>e2[0]
    }
  end
end
