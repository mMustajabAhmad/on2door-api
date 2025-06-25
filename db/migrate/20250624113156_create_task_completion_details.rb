class CreateTaskCompletionDetails < ActiveRecord::Migration[7.1]
  def change
    create_table :task_completion_details do |t|

      t.timestamps
    end
  end
end
