class Task < ApplicationRecord
  include ActiveModel::Dirty

  belongs_to :recipient
  has_one :address, as: :addressable, dependent: :destroy
  has_one :feedback, dependent: :destroy
  has_one :task_completion_detail, dependent: :destroy
  # Tasks this task links to (outgoing)
  has_many :task_links, class_name: 'LinkedTask', foreign_key: 'task_id', dependent: :destroy
  has_many :linked_tasks, through: :task_links, source: :linked_task
  # Tasks that link to this task (incoming)
  has_many :inverse_task_links, class_name: 'LinkedTask', foreign_key: 'linked_task_id', dependent: :destroy
  has_many :inverse_linked_tasks, through: :inverse_task_links, source: :task
  belongs_to :administrator
  belongs_to :driver, optional: true
  belongs_to :team, optional: true
  acts_as_tenant :organization

  accepts_nested_attributes_for :recipient
  accepts_nested_attributes_for :address

  enum :state, [:unassigned, :assigned, :active, :completed, :failed]

  validates :recipient, presence: true
  validates :address, presence: true
  validates :pickup_task, inclusion: {in: [true, false]}
  validate :valid_state_transition
  validate :linked_tasks_completion

  before_create :generate_short_id
  after_initialize :set_default_state, if: :new_record?
  before_save :update_state_on_assignment
  after_update :broadcast_state_change

  def self.ransackable_attributes(auth_object = nil)
    ["state", "short_id", "pickup_task", "complete_after", "complete_before"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["driver", "team", "recipient"]
  end

  private
    def generate_short_id
      loop do
        self.short_id = SecureRandom.alphanumeric(8).upcase
        break unless Task.exists?(short_id: short_id)
      end
    end

    def update_state_on_assignment
      if driver_id.present? && driver_id_changed?
        self.state = :assigned
      else
        self.state = :unassigned if driver_id.nil? && driver_id_changed?
      end
    end

    def set_default_state
      self.state ||= :unassigned
    end

    def valid_state_transition
      if state_changed?
        if (state == "completed" || state == "failed") && state_was != "active"
          errors.add(:state, "must be active before it can be completed or failed")
        end
      end
    end
    
    def linked_tasks_completion
      if state_changed? && state == "active"
        incomplete_linked_tasks = linked_tasks.where.not(state: "completed")

        if incomplete_linked_tasks.exists?
          errors.add(:state, "cannot be set to active until all linked tasks are completed")
        end
      end
    end

    def broadcast_state_change
      if state_changed?
        ActionCable.server.broadcast("task_#{id}", {
          type: 'state_change',
          task_id: id,
          old_state: state_was,
          new_state: state,
          updated_at: Time.current.iso8601,
          driver_id: driver_id,
          administrator_id: administrator_id
        })

        if state == 'completed' || state == 'failed'
          ActionCable.server.broadcast("task_#{id}", {
            type: 'tracking_closed',
            task_id: id,
            reason: state,
            timestamp: Time.current.iso8601
          })
        end
      end
    end
end
