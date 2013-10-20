json.array!(@employees) do |employee|
  json.extract! employee, :full_name
  json.url employee_url(employee, format: :json)
end
