class CreateFeedbacks < ActiveRecord::Migration[7.2]
  def change
    create_table :feedbacks do |t|
      t.text :comment
    
      t.timestamps
    end
    add_reference :feedbacks, :task, foreign_key: true
  end
end
