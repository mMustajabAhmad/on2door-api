class AddIsActiveToDrivers < ActiveRecord::Migration[7.2]
  def change
    add_column :drivers, :is_active, :boolean
  end
end
