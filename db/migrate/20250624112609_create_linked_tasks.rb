class CreateLinkedTasks < ActiveRecord::Migration[7.1]
  def change
    create_table :linked_tasks do |t|
      t.references :task, null: false, foreign_key: {to_table: :tasks}
      t.references :linked_task, null: false, foreign_key: {to_table: :tasks}
      
      t.timestamps
    end
  end
end
