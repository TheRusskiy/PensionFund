module CompaniesHelper
  def company_items
    Company.all.map{|e|
      [e.name, e.id]
    }.sort!{|e1,e2|
      e1[0]<=>e2[0]
    }
  end
end
