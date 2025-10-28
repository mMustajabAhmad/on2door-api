class Api::V1::Administrators::TaskSerializer
  include JSONAPI::Serializer

  attributes :id, :short_id, :pickup_task, :complete_after, :complete_before, :destination_notes, :linked_task_ids, :service_time, :quantity, :state, :created_at, :driver_id, :team_id, :recipient_id, :address_id, :task_completion_requirements

  attribute :recipient_attributes do |task|
    return nil unless task.recipient

    {
      name: task.recipient.name,
      email: task.recipient.email,
      phone_number: task.recipient.phone_number 
    }
  end

  attribute :address_attributes do |task|
    return nil unless task.address

    {
      name: task.address.name,
      street: task.address.street,
      street_number: task.address.street_number,
      appartment: task.address.appartment,
      city: task.address.city,
      state: task.address.state,
      postal_code: task.address.postal_code,
      country: task.address.country,
      longitude: task.address.longitude,
      latitude: task.address.latitude
    }
  end
end
