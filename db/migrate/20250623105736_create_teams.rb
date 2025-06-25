class CreateTeams < ActiveRecord::Migration[7.1]
  def change
    create_table :teams do |t|
      t.string :name
      t.boolean :enable_self_assign

      t.timestamps
    end
    add_reference :teams, :organization, foreign_key: true
    add_reference :teams, :hub, foreign_key: true
  end
end
