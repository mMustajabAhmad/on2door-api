class CreateFeedbacks < ActiveRecord::Migration[7.2]
  def up
    create_table :feedbacks do |t|
      t.text :comment

      t.timestamps
    end

    add_reference :feedbacks, :task, foreign_key: true
  end

  def down
    drop_table :feedbacks
  end
end