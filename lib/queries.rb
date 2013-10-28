module Queries
  def self.inspector_query(company, average, from_year, from_month, to_year, to_month)
    emps = Employee.where(id: Employee.joins(:payments).select('employees.id').where(
        "payments.year" => from_year..to_year,
        "payments.month" => from_month..to_month,
        "payments.company_id" => company
    ).group('employees.id').having("avg(amount) >= ?", average))
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
           year]

    # public base.sanitize is buggy, have to use protected base.sanitize_sql_array
    sanitized_sql = ActiveRecord::Base.send(:sanitize_sql_array, sql)

    result = ActiveRecord::Base.connection.execute(sanitized_sql)

    # ideally companies should be fetched by single query and then mapped by company_id's
    result.each { |r| r['company'] = Company.find(r['company_id']) }
  end
end