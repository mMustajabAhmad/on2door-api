class Api::V1::Drivers::ScheduleSerializer
  include JSONAPI::Serializer

  attributes :id, :date, :driver_id, :created_at, :updated_at

  attribute :subschedules do |schedule|
    schedule.subschedules.map do |subschedule|
      {
        id: subschedule.id,
        shift_start: subschedule.shift_start,
        shift_end: subschedule.shift_end,
        created_at: subschedule.created_at,
        updated_at: subschedule.updated_at
      }
    end
  end
end
