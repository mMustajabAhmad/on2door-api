class AddPendingTeamIdsToAdministrators < ActiveRecord::Migration[7.2]
  def up
    add_column :administrators, :pending_team_ids, :integer, array: true, default: nil
  end

  def down
    remove_column :administrators, :pending_team_ids
  end
end
