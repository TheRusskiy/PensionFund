class CreateContracts < ActiveRecord::Migration
  def change
    create_table :contracts do |t|
      t.timestamps
    end
  end
end
