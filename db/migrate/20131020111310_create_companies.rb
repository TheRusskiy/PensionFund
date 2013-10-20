class CreateCompanies < ActiveRecord::Migration
  def change
    create_table :companies do |t|
      t.integer :vat
      t.string :name
      t.string :district
      t.timestamps
    end
  end
end
