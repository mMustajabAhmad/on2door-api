class Task < ApplicationRecord
  belongs_to :recipient
  has_one :feedback, dependent: :destroy
  has_one :task_completion_detail, dependent: :destroy
  # Tasks this task links to
  has_many :linked_task_joins, class_name: 'LinkedTask', foreign_key: 'task_id', dependent: :destroy
  has_many :linked_tasks, through: :linked_task_joins, source: :linked_task
  # Tasks that link to this task
  has_many :inverse_linked_task_joins, class_name: 'LinkedTask', foreign_key: 'linked_task_id', dependent: :destroy
  has_many :inverse_linked_tasks, through: :inverse_linked_task_joins, source: :task
  belongs_to :administrator
  acts_as_tenant :organization
end
