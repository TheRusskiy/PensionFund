class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create

  def role
    case role_id
      when 0 then "guest"
      when 1 then "admin"
      when 2 then "operator"
      when 3 then "inspector"
      when 4 then "manager"
    else raise Exception "Unknown role_id"
  end
  end
end
