class CreateVehicles < ActiveRecord::Migration[7.2]
  def up
    create_table :vehicles do |t|
      t.string :license_plate, null: false
      t.integer :vehicle_type
      t.string :color
      t.text :description
      t.references :driver, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :vehicles
  end
end
