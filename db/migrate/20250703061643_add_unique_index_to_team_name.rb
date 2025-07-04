class AddUniqueIndexToTeamName < ActiveRecord::Migration[7.2]
  def up
    add_index :teams, [:organization_id, :name], unique: true
  end

  def down
    remove_index :teams, column: [:organization_id, :name]
  end
end
