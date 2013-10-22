class PaymentUniqueFields < ActiveRecord::Migration
  def change
    add_index :payments, [:company_id, :employee_id, :year, :month], unique: true, name: 'unique_fields'
  end
end
