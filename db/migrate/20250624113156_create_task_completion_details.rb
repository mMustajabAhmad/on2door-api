class CreateTaskCompletionDetails < ActiveRecord::Migration[7.2]
  def up
    create_table :task_completion_details do |t|
      t.string :failure_reason
      t.boolean :success
      t.time :datetime
      t.string :signature_upload_id
      t.string :photo_upload_id
      t.string :distance
      t.string :notes
      t.jsonb :task_completion_events
      t.float :first_location, array: true, default: []
      t.float :last_location, array: true, default: []

      t.timestamps
    end
  end

  def down
    drop_table :task_completion_details
  end
end