json.array!(@transfers) do |transfer|
  json.extract! transfer, :company_id, :transfer_date, :amount, :month, :year
  json.url transfer_url(transfer, format: :json)
end
