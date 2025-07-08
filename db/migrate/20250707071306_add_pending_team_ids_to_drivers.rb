class AddPendingTeamIdsToDrivers < ActiveRecord::Migration[7.2]
  def up
    add_column :drivers, :pending_team_ids, :integer, array: true, default: nil
  end

  def down
    remove_column :drivers, :pending_team_ids
  end
end
