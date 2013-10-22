module CompaniesHelper
  def company_items companies = Company.all
    companies.map{|e|
      [e.name, e.id]
    }.sort!{|e1,e2|
      e1[0]<=>e2[0]
    }
  end

end
