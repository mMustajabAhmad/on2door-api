class CreateTeams < ActiveRecord::Migration[7.2]
  def up
    create_table :teams do |t|
      t.string :name
      t.references :organization, foreign_key: true
      t.references :hub, foreign_key: true

      t.timestamps
    end

    add_index :teams, [:organization_id, :name], unique: true
  end

  def down
    remove_index :teams, column: [:organization_id, :name]
    drop_table :teams
  end
end
