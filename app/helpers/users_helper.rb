module UsersHelper
  def role_items
    items = []
    for r in 0..4 do
      items << [User.role_name(r), r]
    end
    items
  end
end
