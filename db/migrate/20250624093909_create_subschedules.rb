class CreateSubschedules < ActiveRecord::Migration[7.2]
  def up
    create_table :subschedules do |t|
      t.references :schedule, null: false, foreign_key: true
      t.datetime :shift_start
      t.datetime :shift_end

      t.timestamps
    end
  en
  def down
    drop_table :subschedules
  end
end
