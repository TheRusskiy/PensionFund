class CreateJobPositions < ActiveRecord::Migration
  def change
    create_table :job_positions do |t|
      t.string :name

      t.timestamps
    end
  end
end
