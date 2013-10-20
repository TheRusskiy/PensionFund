class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :year
      t.integer :month
      t.integer :amount

      t.timestamps
    end
  end
end
