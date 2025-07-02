class RemoveNameFromDrivers < ActiveRecord::Migration[7.2]
  def change
    remove_column :drivers, :name, :string
  end
end
