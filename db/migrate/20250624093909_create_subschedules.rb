class CreateSubschedules < ActiveRecord::Migration[7.1]
  def change
    create_table :subschedules do |t|
      t.references :schedules, null: false, foreign_key: true
      t.datetime :shift_start
      t.datetime :shift_end
      
      t.timestamps
    end
  end
end
