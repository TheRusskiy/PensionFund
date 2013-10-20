class CreateTransfers < ActiveRecord::Migration
  def change
    create_table :transfers do |t|
      t.date :transfer_date
      t.integer :amount
      t.integer :month
      t.integer :year

      #t.belongs_to :company
      t.timestamps
    end
  end
end
