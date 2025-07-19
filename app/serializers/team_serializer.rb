class TeamSerializer
  include JSONAPI::Serializer

  attributes :id, :name, :organization_id, :hub_id, :dispatchers_count, :drivers_count
end
