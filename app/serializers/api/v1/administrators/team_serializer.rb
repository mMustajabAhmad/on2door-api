class Api::V1::Administrators::TeamSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :organization_id, :hub_id, :dispatchers_count, :drivers_count

  attribute :dispatchers do |team|
    team.administrators.dispatcher.map do |admin|
      {
        id: admin.id,
        name: [admin.first_name, admin.last_name].compact.join(' ').strip
      }
    end
  end

  attribute :drivers do |team|
    team.drivers.map do |driver|
      {
        id: driver.id,
        name: [driver.first_name, driver.last_name].compact.join(' ').strip
      }
    end
  end
end
