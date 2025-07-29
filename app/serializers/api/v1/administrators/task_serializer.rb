class Api::V1::Administrators::TaskSerializer
  include JSONAPI::Serializer

  attributes :id, :short_id, :pickup_task, :complete_after, :complete_before, :destination_notes, :linked_task_ids, :service_time, :quantity, :state, :created_at, :driver_id, :team_id, :recipient_id, :address_id, :task_completion_requirements
end
