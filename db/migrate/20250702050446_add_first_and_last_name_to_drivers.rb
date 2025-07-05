class AddFirstAndLastNameToDrivers < ActiveRecord::Migration[7.2]
  def change
    add_column :drivers, :first_name, :string
    add_column :drivers, :last_name, :string
  end
end
