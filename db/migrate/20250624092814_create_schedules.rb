class CreateSchedules < ActiveRecord::Migration[7.2]
  def up
    create_table :schedules do |t|
      t.datetime :date
      t.references :driver, null: false, foreign_key: true

      t.timestamps
    end
  end

  def down
    drop_table :schedules
  end
end
