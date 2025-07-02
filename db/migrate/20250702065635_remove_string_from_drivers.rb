class RemoveStringFromDrivers < ActiveRecord::Migration[7.2]
  def change
    remove_column :drivers, :string, :string
  end
end
