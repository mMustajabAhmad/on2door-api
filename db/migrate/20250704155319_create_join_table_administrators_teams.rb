class CreateJoinTableAdministratorsTeams < ActiveRecord::Migration[7.2]
  def up
    create_join_table :administrators, :teams do |t|
      t.index [:administrator_id, :team_id], unique: true
      t.index [:team_id, :administrator_id]
    end
  end

  def down
    drop_join_table :administrators, :teams
  end
end
