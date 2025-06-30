class RemoveNameFromAdministrators < ActiveRecord::Migration[7.2]
  def change
    remove_column :administrators, :name, :string
  end
end
