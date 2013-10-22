class User < ActiveRecord::Base
  has_secure_password
  validates_presence_of :password, :on => :create
  validates_presence_of :email, :role_id
  validates_uniqueness_of :email

  def role
    User.role_name role_id
  end

  def self.role_name role_number
    case role_number
      when 0 then I18n.t "user.guest"
      when 1 then I18n.t "user.admin"
      when 2 then I18n.t "user.operator"
      when 3 then I18n.t "user.inspector"
      when 4 then I18n.t "user.manager"
      else raise Exception "Unknown role_id"
    end
  end
end
