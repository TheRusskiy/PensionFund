class Associations < ActiveRecord::Migration
  def change
    change_table :companies  do |t|
      t.belongs_to :property_type
    end

    change_table :transfers  do |t|
      t.belongs_to :company
    end

    change_table :payments do |t|
      t.belongs_to :company
      t.belongs_to :employee
    end

    change_table :contracts do |t|
      t.belongs_to :employee
      t.belongs_to :company
      t.belongs_to :job_position
    end
  end
end
