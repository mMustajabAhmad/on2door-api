class CreateVehicles < ActiveRecord::Migration[7.1]
  def change
    create_table :vehicles do |t|
      t.string :license_plate
      t.string :vehicle_type
      t.string :color 
      t.string :description
      t.references :drivers, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
