class CreateJoinTableAdministratorsTeams < ActiveRecord::Migration[7.1]
  def change
    create_join_table :administrators, :teams do |t|
      t.index [:administrator_id, :team_id], unique: true
      t.index [:team_id, :administrator_id]
    end
  end
end
