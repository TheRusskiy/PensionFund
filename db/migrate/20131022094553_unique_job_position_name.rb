class UniqueJobPositionName < ActiveRecord::Migration
  def change
    add_index(:job_positions, [:name], unique: true)
  end
end
