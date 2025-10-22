class AddJtiToDrivers < ActiveRecord::Migration[7.2]
  def change
    add_column :drivers, :jti, :string, null:false
    add_index :drivers, :jti, unique: true
  end
end
