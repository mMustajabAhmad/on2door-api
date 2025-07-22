class LinkedTask < ApplicationRecord
    belongs_to :task
    belongs_to :linked_task, class_name: 'Task'
end
