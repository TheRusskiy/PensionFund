module Queries
  def self.inspector_query(company, average, from_year, from_month, to_year, to_month)
    company = company.id if company.respond_to? :id
    emps = Employee.where(id: Employee.joins(:payments).select('employees.id').where(
        ["payments.year*12+payments.month BETWEEN ? AND ?
          AND payments.company_id = ?",
         (from_year.to_i*12+from_month.to_i),(to_year.to_i*12+to_month.to_i), company]
    ).group('employees.id').having("avg(amount) >= ?", average.to_i))
    # we need all data, not just id's
    # we can use:
    # Employee.where(id: emps)
    # or just:
    emps.reload
  end

  def self.manager_query year
    sql = ['SELECT '+
             'avg(payments.amount) as amount, companies.id as company_id, payments.month as month '+
           'FROM '+
             'companies, payments, employees '+
           'WHERE '+
             'companies.id = payments.company_id '+
             'AND employees.id = payments.employee_id '+
             'AND payments.year = ? '+
           'GROUP BY '+
             'companies.id, payments.month',
           year.to_i]

    # public base.sanitize is buggy, have to use protected base.sanitize_sql_array
    sanitized_sql = ActiveRecord::Base.send(:sanitize_sql_array, sql)

    result = ActiveRecord::Base.connection.execute(sanitized_sql)

    # ideally companies should be fetched by single query and then mapped by company_id's
    result.map { |r| r['company'] = Company.find(r['company_id']); r }
  end
end