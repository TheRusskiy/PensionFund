module PropertyTypesHelper
  def property_type_items
    PropertyType.all.map{|e| [e.name, e.id]}
  end
end
