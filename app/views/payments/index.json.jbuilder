json.array!(@payments) do |payment|
  json.extract! payment, :company_id, :employee_id, :year, :month, :amount
  json.url payment_url(payment, format: :json)
end
