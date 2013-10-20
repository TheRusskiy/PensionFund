class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :company_id
      t.string :employee_id
      t.integer :year
      t.integer :month
      t.integer :amount

      t.timestamps
    end
  end
end
