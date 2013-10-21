json.array!(@contract) do |contract|
  json.extract! contract, :company_id, :employee_id, :job_position_id
  json.url contract_url(contract, format: :json)
end
