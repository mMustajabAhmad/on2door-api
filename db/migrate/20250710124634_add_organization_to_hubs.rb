class AddOrganizationToHubs < ActiveRecord::Migration[7.2]
  def up
    add_reference :hubs, :organization, foreign_key: true
    add_index :hubs, [:organization_id, :name], unique: true
  end

  def down
    remove_index :hubs, column: [:organization_id, :name]
    remove_reference :hubs, :organization, foreign_key: true
  end
end
