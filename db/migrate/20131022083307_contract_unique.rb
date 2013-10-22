class ContractUnique < ActiveRecord::Migration
  def change
    add_index(:contracts, [:company_id, :employee_id], unique: true)
  end
end
