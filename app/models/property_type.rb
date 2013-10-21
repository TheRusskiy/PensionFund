class PropertyType < ActiveRecord::Base
  has_many :companies

  def to_s
    name
  end
end
