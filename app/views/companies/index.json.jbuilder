json.array!(@companies) do |company|
  json.extract! company, :vat, :name, :district, :property_type
  json.url company_url(company, format: :json)
end
