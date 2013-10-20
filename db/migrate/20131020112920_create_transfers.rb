class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.integer :company_id
      t.date :transfer_date
      t.integer :amount
      t.integer :month
      t.integer :year

      t.timestamps
    end
  end
end
