class Api::V1::Drivers::SubscheduleSerializer
  include JSONAPI::Serializer

  attributes :id, :shift_start, :shift_end, :schedule_id, :created_at, :updated_at

  attribute :schedule_date do |subschedule|
    subschedule.schedule.date
  end
end
