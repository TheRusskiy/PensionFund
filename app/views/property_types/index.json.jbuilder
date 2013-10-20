json.array!(@property_types) do |property_type|
  json.extract! property_type, :name
  json.url property_type_url(property_type, format: :json)
end
