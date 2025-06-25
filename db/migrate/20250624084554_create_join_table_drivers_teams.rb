class CreateJoinTableDriversTeams < ActiveRecord::Migration[7.1]
  def change
    create_join_table :drivers, :teams do |t|
      t.index [:driver_id, :team_id], unique: true
      t.index [:team_id, :driver_id]
    end
  end
end
