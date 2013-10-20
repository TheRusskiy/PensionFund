class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.integer :employee_id
      t.integer :company_id
      t.integer :job_position_id

      t.timestamps
    end
  end
end
