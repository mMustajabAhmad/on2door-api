class CreateSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :schedules do |t|
      t.datetime :date
      t.references :drivers, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
