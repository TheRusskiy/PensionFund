class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :role_id
  validates_uniqueness_of :email

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
