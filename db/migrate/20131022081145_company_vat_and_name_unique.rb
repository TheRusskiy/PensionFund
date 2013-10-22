class CompanyVatAndNameUnique < ActiveRecord::Migration
  def change
    add_index(:companies, [:vat], unique: true)
    add_index(:companies, [:name], unique: true)
  end
end
