class CreateTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :tasks do |t|
      t.string :short_id
      t.datetime :complete_after
      t.datetime :complete_before
      t.datetime :eta
      t.datetime :ect
      t.datetime :delay_time
      t.boolean :pickup_task
      t.string :destination_notes
      t.integer :quantity
      t.datetime :service_time
      t.string :tracking_url
      t.jsonb :task_completion_requirements
      t.integer :state

      t.timestamps
    end

    add_reference :tasks, :organization, foreign_key: true
    add_reference :tasks, :driver, foreign_key: true
    add_reference :tasks, :team, foreign_key: true
    add_reference :tasks, :creator, foreign_key: { to_table: :administrators }
    add_reference :tasks, :recipient, foreign_key: true
  end
end
