class AddJtiToDrivers < ActiveRecord::Migration[7.1]
  def change
    add_column :drivers, :jti, :string
    add_index :drivers, :jti
  end
end
